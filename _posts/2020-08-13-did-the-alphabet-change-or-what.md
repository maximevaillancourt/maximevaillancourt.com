---
title: "Two Ruby apps, same code, different output"
layout: post
slug: "debugging-ruby-casecmp-bug-using-gdb"
excerpt: Debugging a weird Ruby string sorting issue with GDB.
image: https://images.unsplash.com/photo-1522776851755-3914469f0ca2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&h=500&q=80
---

I noticed something odd today while working on two different Ruby codebases. This simple line of Ruby behaved differently in both applications:

```rb
"luck".casecmp("L`auguste")
```

Executing ``"luck".casecmp("L`auguste")`` in application A returned `-1`, while executing it in application B returned `1`.

"Did the alphabet change at some point and I didn't get the memo?", I thought.

> **Aside**
> 
> [`String#casecmp`](https://ruby-doc.org/core-2.7.1/String.html#method-i-casecmp) is a built-in Ruby method that returns `-1`, `0`, `1`, or `nil` depending on whether the object on which it's called is less than, equal to, or greater than the function argument, and it does so in case-insensitive fashion. Here are a few simple examples of how it behaves:
> 
> ```rb
> "aBcDeF".casecmp("abcde")     #=> 1
> "aBcDeF".casecmp("abcdef")    #=> 0
> "aBcDeF".casecmp("abcdefg")   #=> -1
> "abcdef".casecmp("ABCDEF")    #=> 0
> ```

## Looking for monkey patches

Seeing as one of the applications is built on top of Ruby of Rails and the other isn't, my first thought was that maybe there was a Rails and/or ActiveSupport patch on `String#casecmp` that would change the behavior of this line in one of the applications. However, I didn't find anything that pointed to this. I kept digging, hoping to maybe find a patch in the _other_ application that could explain this difference in behavior. Again, I didn't find anything. 🙈

## Different Rubies

Eventually, after exploring a bit more, I realized that both applications ran on different versions of Ruby: application A was on Ruby 2.6, while application B was using Ruby 2.7.

Running the same command on both versions of Ruby indeed gives us different results:

```sh
$ ~/.rubies/ruby-2.6.6/bin/ruby -e 'puts "luck".casecmp("L`Auguste")'
-1

$ ~/.rubies/ruby-2.7.0/bin/ruby -e 'puts "luck".casecmp("L`Auguste")'
1
```

Ah ha! We're getting closer. While I could have called it a day here and simply updated application B to Ruby 2.7 to resolve the issue, I wanted to understand: what causes it?

## Changelogs & `binding.pry`

I then started to comb through Ruby changelogs, trying to find if anything changed between Ruby 2.6 and Ruby 2.7 for `String#casecmp`, or anything somehow related to string comparison. I didn't find anything.

Of course, it would be nice to debug this using `binding.pry` or other similar Ruby-level debugging tools by stepping into the `String#casecmp` call to see what's going on inside. However, this doesn't get us very far, as trying to use Ruby's `Tracer` or `binding.pry` doesn't really help.

Running this:

```sh
$ ruby -r tracer -e '"luck".casecmp("L`Auguste")'
```

returns this output:

```
#0:-e:1::-: "luck".casecmp("L`Auguste")
```

and not much else. That's because `String#casecmp` is implemented in C, directly inside MRI's [`string.c`](https://github.com/ruby/ruby/blob/master/string.c), so there's no actual Ruby code underneath `String#casecmp` that we can step into using Ruby-level debugging tools.

Here comes the GDB part: because we're essentially dealing with C code at this point, we can use GDB to understand what happens inside the call to `String#casecmp`. So with that, I fired up GDB for the first time in years (I typically work with Ruby, so GDB is not something I commonly use).

## Identifying the root cause using GDB

Let's see how to use GDB to understand why both Ruby 2.6 and Ruby 2.7 behave differently with the same input to `String#casecmp`.

I first prepared a simple Ruby file containing the source that replicates the issue:

```rb
# ~/casecmp.rb
puts "luck".casecmp("L`Auguste")
```

Notice that the second character in the input to `casecmp` is a backtick (`` ` ``), which has ASCII code 96. This is relevant for paragraphs below.

### In Ruby 2.7.0

Let's start by firing up GDB with a self-compiled version of Ruby 2.7.0:

```sh
$ sudo gdb /Users/maximevaillancourt/.rubies/ruby-2.7.0/bin/ruby
Reading symbols from /Users/maximevaillancourt/.rubies/ruby-2.7.0/bin/ruby...
```

Then, we add a breakpoint on the `str_casecmp` function so execution pauses once we reach it:

```
(gdb) break str_casecmp
Breakpoint 1 at 0x1001fa766: file string.c, line 3371.
```

Perfect. We're now ready to run the `casecmp.rb` Ruby script from above.

```
(gdb) run casecmp.rb
Starting program: /Users/maximevaillancourt/.rubies/ruby-2.7.0/bin/ruby casecmp.rb
```

We eventually hit the breakpoint we just set:

```
Thread 2 hit Breakpoint 1, str_casecmp (str1=4329352680, str2=4329352640) at string.c:3371
3371	    enc = rb_enc_compatible(str1, str2);
```

> **Aside**
> 
> Internally, [`String#str_casecmp`](https://github.com/ruby/ruby/blob/4318aba9c94ebff53e4168886e1a35a24013924f/string.c#L3467-L3468) is quite simple: it iterates over each character in both inputs by index starting from the first character, converting both characters to the same case so that the function behaves in a case-insensitive way, and returns early if the two currently considered characters from each input are different. In doing so, it determines which character is "bigger" than the other using the character code (an [ASCII code table](http://www.asciitable.com/) is a useful asset to have nearby for the rest of this blog post).

In Ruby 2.7.0, notice that the case conversion [converts both inputs to lowercase using `TOLOWER`](https://github.com/ruby/ruby/blob/e9e4f8430a62f56a4e62dd728f4498ee4c300c12/string.c#L3381-L3382):

```c
while (p1 < p1end && p2 < p2end) {
  if (*p1 != *p2) {
    unsigned int c1 = TOLOWER(*p1 & 0xff);
    unsigned int c2 = TOLOWER(*p2 & 0xff);
    if (c1 != c2)
      return INT2FIX(c1 < c2 ? -1 : 1);
  }
  p1++;
  p2++;
}
```

After navigating in `str_casecmp` using `next` a few times, we enter the loop and arrive at a point where we can print `c1` and `c2`, which are the codes for the characters at the current index for both inputs:

```
3382	                unsigned int c2 = TOLOWER(*p2 & 0xff);
(gdb) print c1
$11 = 108
(gdb) next
3383	                if (c1 != c2)
(gdb) print c2
$12 = 108
```

Here's a visual representation of the buffers:

```
c1
 ↓
108  ?   ?   ?
 l   u   c   k

108  ?   ?   ?   ?   ?   ?   ?   ?
 l   `   a   u   g   u   s   t   e
 ↑
c2
```

108 is the decimal ASCII character code representation for the first letter of both inputs: `l` (lowercase "L"), so the loop continues to the next iteration because `c1` and `c2` are the same.

On the second iteration of the loop (on the second character of both inputs), we get the following results:

```
3382	                unsigned int c2 = TOLOWER(*p2 & 0xff);
(gdb) print c1
$14 = 117
(gdb) next
3383	                if (c1 != c2)
(gdb) print c2
$16 = 96
```

Here's a visual representation of the buffers:

```
    c1
     ↓
108 117  ?   ?
 l   u   c   k

108  96  ?   ?   ?   ?   ?   ?   ?
 l   `   a   u   g   u   s   t   e
     ↑
     c2
```

`c1` contains `117`, which is the decimal ASCII character code representation for `u`, while `96` (in `c2`) is the character code for a backtick (`` ` ``). We then enter the `if (c1 != c2)` conditional, and the return value is `1` because `c1 > c2` (`117 > 96`).

Okay. So far so good. This lines up with the initial observation of the issue. How are things different in Ruby 2.6.6?

### In Ruby 2.6.6

We do almost the same setup as above (same one-line Ruby script to replicate the issue, same breakpoint on `str_casecmp`), but we fire up GDB with Ruby 2.6.6:

```sh
$ sudo gdb /Users/maximevaillancourt/.rubies/ruby-2.6.6/bin/ruby
Reading symbols from /Users/maximevaillancourt/.rubies/ruby-2.6.6/bin/ruby...

(gdb) break str_casecmp
...

(gdb) run casecmp.rb
Starting program: /Users/maximevaillancourt/.rubies/ruby-2.6.6/bin/ruby casecmp.rb

Thread 2 hit Breakpoint 1, str_casecmp ...
```

Let's look at the loop we presented above in Ruby 2.7.0, but [in Ruby 2.6.6](https://github.com/ruby/ruby/blob/a9a48e6a741f048766a2a287592098c4f6c7b7c7/string.c#L3413-L3414) this time:

```c
while (p1 < p1end && p2 < p2end) {
  if (*p1 != *p2) {
    unsigned int c1 = TOUPPER(*p1 & 0xff);
    unsigned int c2 = TOUPPER(*p2 & 0xff);
    if (c1 != c2)
      return INT2FIX(c1 < c2 ? -1 : 1);
  }
  p1++;
  p2++;
}
```

Notice that instead of using `TOLOWER` as in Ruby 2.7.0, Ruby 2.6.6 uses `TOUPPER`. Interesting.

Let's fast-forward to the part where we get to `c1` and `c2` for the second character in the input:

```
3414			unsigned int c2 = TOUPPER(*p2 & 0xff);
(gdb) next
3415	                if (c1 != c2)
(gdb) print c1
$5 = 85
(gdb) print c2
$6 = 96
```

Here's a visual representation of the buffers:

```
     c1
     ↓
108  85  ?   ?
 L   U   C   K

108  96  ?   ?   ?   ?   ?   ?   ?
 L   `   A   U   G   U   S   T   E
     ↑
     c2
```

`c1` is `85`, which is the character code for `U`, and `c2` is `96` (just like in Ruby 2.7.0), which is the character code for a backtick (`` ` ``).

This time though, the comparison result is different, because `c1 < c2` (`85 < 96`), so `str_casecmp` returns `-1`.

There it is: because Ruby 2.6 uses `TOUPPER` and Ruby 2.7 uses `TOLOWER` before comparing the inputs, and because one of the characters to compare is a backtick (`` ` ``, which can't be converted to uppercase or lowercase in any way), the other character's code "moves" differently around the "fixed" backtick character code, affecting the result of the `String#casecmp` function.

-----

To summarize, the root cause of the issue is that `String#casecmp` was updated in Ruby 2.7 to **lowercase** the two inputs before comparing them, while Ruby 2.6 used to **uppercase** the two inputs before comparing them. [This is the commit where this change was introduced.](https://github.com/ruby/ruby/commit/082424ef58116db9663a754157d6c441d60fd101#diff-7a2f2c7dfe0bf61d38272aeaf68ac768)

Fun debugging session. :)
