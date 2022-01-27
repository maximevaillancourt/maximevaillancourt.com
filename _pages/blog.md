---
layout: default
title: Blog archives
permalink: /blog
---

<div>
  <h1 class="post-title">All blog posts</h1>
  {% for post in site.posts limit: post_limit %}
  <div class="list-entry">
    <div><a class="internal-link" href="{{ post.url }}">{{ post.title }}</a> <span class="faded">({{ post.date | date: "%Y-%m-%d" }})</span></div>
    <div>{{ post.excerpt }}</div>
  </div>
  {% endfor %}
  <br>
  That's it: you reached the end of this list. :)
</div>
