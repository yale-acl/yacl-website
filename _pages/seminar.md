---
title: Seminar
subtitle: Weekly cryptography and security talks — Fridays at 11am ET
permalink: /seminar/
---

<div class="seminar-resources">
  <h2>Resources</h2>
  <ul>
    <li><a href="{{ site.zoom_link }}" target="_blank" rel="noopener">Livestream via Zoom</a></li>
    <li><a href="{{ site.mailing_list }}" target="_blank" rel="noopener">Join the mailing list</a> for announcements</li>
    <li><a href="{{ site.youtube_archive }}" target="_blank" rel="noopener">Past talks on YouTube</a></li>
    <li><a href="{{ site.calendar_embed }}" target="_blank" rel="noopener">Google Calendar</a></li>
    <li>Contact: <a href="mailto:{{ site.email }}">{{ site.email }}</a></li>
  </ul>
</div>

<h2>Upcoming Talks</h2>
<div class="seminar-full-list">
  {% for talk in site.data.seminars.upcoming %}
  {% assign date_parts = talk.date | split: "-" %}
  {% assign month_num = date_parts[1] %}
  {% assign months = "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec" | split: "," %}
  {% assign month_index = month_num | minus: 1 %}
  {% assign month_name = months[month_index] %}
  <div class="seminar-card">
    <div class="seminar-date">
      <span class="month">{{ month_name }}</span>
      <span class="day">{{ date_parts[2] }}</span>
      <span class="year">{{ date_parts[0] }}</span>
    </div>
    <div class="seminar-info">
      <h3>{{ talk.title }}</h3>
      <p class="seminar-meta">
        <strong>{{ talk.speaker }}</strong> &mdash; {{ talk.affiliation }}
      </p>
      {% if talk.abstract %}
      <p style="font-size:.875rem;color:#555;margin-top:.4rem;">{{ talk.abstract }}</p>
      {% endif %}
      <p class="seminar-time">{{ talk.time }}</p>
    </div>
  </div>
  {% endfor %}
</div>
