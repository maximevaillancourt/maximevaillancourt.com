---
layout: default
title: Home
id: home
redirect_from: "/en"
permalink: /
---

<div>
  <div>
    <p>
      Hello! I'm Maxime. I enjoy solving problems, riding bicycles, and playing music. Welcome to my corner of the Web.
    </p>

    <p>
      Consider taking a few minutes to <a href="/guestbook" class="internal-link">sign the guestbook</a> while you're here. You may also reach me directly on <a href="https://mstdn.io/@vaillancourtmax" target="_blank">Mastodon</a> :)
    </p>
  </div>

  <div>
    <div class="grid-element">
      <h2>Blog posts</h2>
      {% assign post_limit = 7 %}
      {% for post in site.posts limit: post_limit %}
      <div class="list-entry">
        <div><a class="internal-link" href="{{ post.url }}">{{ post.title }}</a> <span class="faded">({{ post.date | date: "%Y-%m-%d" }})</span></div>
        <div>{{ post.excerpt }}</div>
      </div>
      {% endfor %}
      <p>
        <a class="internal-link" href="/blog">I wrote {{ site.posts.size | minus: post_limit }} more posts</a>.
        This blog is also available as <a class="internal-link" target="_blank" href="/rss.xml">RSS</a> and <a class="internal-link" target="_blank" href="/feed.json">JSON</a> feeds.
      </p>
    </div>

    <div class="grid-element">
      <h2>Side projects</h2>

      {% assign project_limit = 2 %}
      {% for project in site.data.projects limit: project_limit %}
      <div class="list-entry">
        <div><a target="_blank" rel="noopener" href="{{ project.url }}">{{ project.name }}</a> <span class="faded">({{ project.date | date: "%Y-%m-%d" }})</span></div>
        <div>{{ project.description_html }}</div>
      </div>
      {% endfor %}

      {% assign additional_projects = site.data.projects.size | minus: project_limit %}
      {% if additional_projects > 0 %}
      <div>
        <p>
          <a class="internal-link" href="/projects">
            View all projects ({{ additional_projects }} more projects)
          </a>
        </p>
      </div>
      {% endif %}
    </div>

    <div class="grid-element">
      <h2>Podcast appearances</h2>

      {% assign podcast_limit = 2 %}
      {% for podcast in site.data.podcasts limit: podcast_limit %}
      <div class="list-entry">
        <div><a target="_blank" rel="noopener" href="{{ podcast.url }}">{{ podcast.name }}</a> <span class="faded">({{ podcast.date | date: "%Y-%m-%d" }})</span></div>
        <div>{{ podcast.description_html }}</div>
      </div>
      {% endfor %}

      {% assign additional_podcasts = site.data.podcasts.size | minus: podcast_limit %}
      {% if additional_podcasts > 0 %}
      <div>
        <p>
          <a class="internal-link" href="/podcasts">
            View all podcasts ({{ additional_podcasts }} more podcasts)
          </a>
        </p>
      </div>
      {% endif %}
    </div>
  </div>
</div>
