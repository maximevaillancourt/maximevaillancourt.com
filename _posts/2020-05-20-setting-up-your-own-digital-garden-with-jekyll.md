---
title: Setting up your own digital garden with Jekyll
layout: post
slug: "setting-up-your-own-digital-garden-with-jekyll"
excerpt: Carve out your own space where you'll seed, cross-pollinate, and grow ideas.
image: https://user-images.githubusercontent.com/8457808/82400515-7d026d80-9a25-11ea-83f1-3b9cb8347e07.png
---

**Eager to try the demo of the template?** 👉 [digital-garden-jekyll-template.netlify.app](https://digital-garden-jekyll-template.netlify.app)

Digital gardens and public note-taking spaces are [all the rage these days](https://twitter.com/ness_labs/status/1262778800649187330), as they're a great way to foster an environment where ideas mesh together and others can take inspiration from. You can set up a digital garden of your own in a few minutes, and have your own personal corner of the Internet where you'll seed and grow ideas.

If you're familiar with Markdown and/or HTML, you'll be right at home, as that's how your notes will be formatted.

The end result will look similar to this:

![](https://user-images.githubusercontent.com/8457808/82400515-7d026d80-9a25-11ea-83f1-3b9cb8347e07.png)

If you happen to use **Obsidian** to work on your notes, you'll likely want to open [this guide from Mike](https://refinedmind.co/obsidian-jekyll-workflow) and read through it in parallel with this one.

Alternatively, if you use **Roam** and would like to automatically convert your Roam Research backup to a garden using this template, take a look at [this repository](https://github.com/DoomHammer/roam-to-git/tree/roam-to-garden).

Without further ado, let's get started!

## Instructions

### 0. Set up prerequisites

For this tutorial, we'll need to install a few things on your machine (you may have some of these already). Following the instructions on each website to install them.

- [Ruby](https://www.ruby-lang.org/)
- [RubyGems](https://rubygems.org/)
- [Git](https://git-scm.com/downloads)

You'll also need to create accounts on the following services:

- [GitHub](https://github.com/join) (to store your digital garden files)
- [Netlify](https://app.netlify.com/signup) (to serve your digital garden website to the world)

Once everything is set up, let's start creating your own digital garden.

### 1. Create a fork of the template repository

To simplify things, I provide the template shown in the image above to get started. You can always tweak this template to your taste later.

Visit the GitHub page for my template repository ([`maximevaillancourt/digital-garden-jekyll-template`](https://github.com/maximevaillancourt/digital-garden-jekyll-template)), and fork it to your account using the Fork button:

![](https://help.github.com/assets/images/help/repository/fork_button.jpg)

Once the forking process is complete, you should have a fork (essentially a copy) of my template in your own GitHub account. On the GitHub page for your repository, click on the green "Clone or download" button, and copy the URL: we'll need it for the next step.


### 2. Clone your repository locally

Next, we want to download the files from your GitHub repository onto your local machine. To do this, replace `<YOUR_COPIED_URL_HERE>` in the command below with the URL you copied in the previous step, then execute this command:

```
$ git clone <YOUR_COPIED_URL_HERE> my-digital-garden
```

As a reference point, this is how it looks like for me (the difference is likely just the GitHub username):

```
$ git clone git@github.com:maximevaillancourt/digital-garden-jekyll-template.git my-digital-garden
```

Then, navigate into the directory that was just created:

```
$ cd my-digital-garden
```

### 3. Test out the site locally

Sweet! You now have your repository's source code on your machine. Within the `my-digital-garden` directory, run the following command to install the necessary dependencies like Jekyll:

```
$ bundle
```

Once that's done, ask Jekyll to start serving the site locally:

```
$ bundle exec jekyll serve
```

Then, open up [`http://localhost:4000`](http://localhost:4000) in your browser.

If everything's done correctly, you should now see the home page of your digital garden. 🎉

Keep in mind that this site is only available locally (notice the `localhost` part of the URL), so if we want it to be available on the Internet for everyone to enjoy, we need to deploy it to the Internet: we'll use Netlify for that in the next step.

### 4. Connect your GitHub repository to Netlify

Netlify lets you automatically deploy your digital garden on to the Internet when you update your GitHub repository. To do this, we need to connect your GitHub repository to Netlify:

1. Log in to [Netlify](https://app.netlify.com/)
2. Once logged in, click the "New site from Git" button
3. On the next page, select GitHub as the continuous deployment provider (you may need to authorize the connection, in which case, approve it)
4. On the next page, select your digital garden repository from the list
5. On the next page, keep the default settings, and click on "Deploy site".

That was easy! We're almost done.

Wait a couple of minutes for the initial deploy to complete.

Once that's done, your digital garden should be available on the Internet via a generic Netlify URL, which you can change to a custom domain later if you'd like.

Now the cool thing is this: whenever you push an update to your GitHub repository, Netlify will automatically deploy your updates to the Internet. 

### 5. Start tending to your digital garden

At this point, you can start updating the files on your machine (in the `my-digital-garden` folder) to change your digital garden to your liking: update the copy, add some notes, tweak the layout, customize the colors, etc.

Once you have something you're happy with, push your changes to your GitHub repository with the following commands:

```
$ git add --all
$ git commit -m 'Update content'
$ git push origin master
```

If that command succeeds and the rest of the tutorial was done correctly, in a couple of minutes, you should see your changes live on your Netlify website. 🚀

And we're done! You now have your own digital garden. Take care of your mind and the rest will follow. 🍃

---

If you're curious, take a look at <a class="internal-link" href="https://maximevaillancourt.com/notes">my own (tiny) digital garden right here</a>.

Similarly, if you made it this far, you'll likely want to join the ["Digital Gardeners" Telegram group](https://nesslabs.com/digital-gardeners): we're a likeminded bunch of folks nerding out on this digital garden thing. Join us! 🧠

If you have any feedback regarding this tutorial, please reach out to me on Twitter ([@vaillancourtmax](https://twitter.com/vaillancourtmax)): I'll be happy to help you out!
