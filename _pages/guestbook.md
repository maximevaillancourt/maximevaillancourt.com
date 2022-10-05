---
layout: default
title: Guestbook
permalink: /guestbook
---

<h1>{{ page.title }} 📖</h1>

That's right &mdash; just like in the early days of the Web. A good old guestbook. Thanks for stopping by! 👋

{% for message in site.data.guestbook_messages reversed %}
  <div class="guestbook-entry">
    <div class="guestbook-entry-author"><span style="font-weight: bold;">{{ message.author }}</span> ({{ message.timestamp | date: "%Y-%m-%d" }})</div>
    <div class="guestbook-entry-body">{{ message.body }}</div>
  </div>
{% endfor %}

The guestbook is currently closed to new signatures.
