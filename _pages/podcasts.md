---
layout: default
title: Podcast appearances
permalink: /podcasts
---

<div>
  <h1 class="post-title">All podcast appearances 👨‍💻</h1>

  {% for podcast in site.data.podcasts %}
  <div class="list-entry">
    <div><a target="_blank" rel="noopener" href="{{ podcast.url }}">{{ podcast.name }}</a> <span class="faded">({{ podcast.date | date: "%Y-%m-%d" }})</span></div>
    <div>{{ podcast.description_html }}</div>
  </div>
  {% endfor %}
</div>
