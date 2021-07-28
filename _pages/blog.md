---
layout: default
title: Blog archives
permalink: /blog
---

<div>
  <div class="post-heading">
    <h1 class="post-title">All blog posts</h1>
  </div>
  {% for post in site.posts limit: post_limit %}
  <div class="list-entry">
    <div><a class="internal-link" href="{{ post.url }}">{{ post.title }}</a> <span class="faded">({{ post.date | date: "%Y-%m-%d" }})</span></div>
    <div>{{ post.excerpt }}</div>
  </div>
  {% endfor %}
  <br>
  <div><p>This blog is also available as <a class="internal-link" target="_blank" href="/rss.xml">RSS</a> and <a class="internal-link" target="_blank" href="/feed.json">JSON</a> feeds.</p></div>
</div>
