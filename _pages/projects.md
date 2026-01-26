---
layout: page
title: week-in-review
permalink: /projects/
description:
nav: false
nav_order: 3
---

<style>
.wir-list {
  list-style: none;
  padding: 0;
  margin: 0;
}
.wir-item {
  display: flex;
  gap: 1.5rem;
  padding: 0.75rem 0;
  border-bottom: 1px solid var(--global-divider-color);
}
.wir-item:last-child {
  border-bottom: none;
}
.wir-date {
  flex-shrink: 0;
  width: 6rem;
  font-size: 0.85rem;
  color: var(--global-text-color-light);
  font-family: monospace;
}
.wir-content {
  flex-grow: 1;
}
.wir-title {
  font-weight: normal;
}
.wir-item.newest .wir-title {
  font-weight: bold;
}
.wir-item.newest .wir-date::after {
  content: " ●";
  color: var(--global-theme-color);
}
.wir-description {
  font-size: 0.85rem;
  color: var(--global-text-color-light);
  margin-top: 0.25rem;
}
</style>

{% assign sorted_projects = site.projects | sort: "date" | reverse %}

<ul class="wir-list">
  {% for project in sorted_projects %}
  <li class="wir-item{% if forloop.first %} newest{% endif %}">
    <span class="wir-date">{{ project.date | date: "%b %d, %Y" }}</span>
    <div class="wir-content">
      <a class="wir-title" href="{{ project.url | relative_url }}">{{ project.title }}</a>
      {% if project.description and project.description != "" %}
      <p class="wir-description">{{ project.description }}</p>
      {% endif %}
    </div>
  </li>
  {% endfor %}
</ul>
