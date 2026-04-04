---
layout: default
title: Home
---

<section class="home-hero">
  <div class="container">
    <img src="/assets/images/yacl_logo_transparent.png" alt="YACL Logo" class="hero-logo">
    <p class="tagline">We are a group of researchers at Yale working on applied cryptography.</p>
  </div>
</section>

<section class="home-section">
  <div class="container">
    <div class="section-header">
      <h2>Updates</h2>
    </div>
    <div class="updates-list">
      {% assign preview_count = site.updates_preview_count | default: 5 %}
      {% assign hidden_count = site.data.updates.size | minus: preview_count %}
      {% for update in site.data.updates %}
        <div class="update-item">
          <span class="update-date">{{ update.date | date: "%b %d, %Y" }}</span>
          <span class="update-body">{% if update.tag %}<span class="update-tag update-tag--{{ update.tag }}">{{ update.tag }}</span> {% endif %}<span class="update-text">{% if update.url %}<a href="{{ update.url }}">{{ update.text | markdownify | remove: '<p>' | remove: '</p>' | strip }}</a>{% else %}{{ update.text | markdownify | remove: '<p>' | remove: '</p>' | strip }}{% endif %}</span></span>
        </div>
        {% if forloop.index == preview_count and hidden_count > 0 %}
        <div class="updates-collapsed" id="updates-more" hidden>
        {% endif %}
      {% endfor %}
      {% if hidden_count > 0 %}</div>{% endif %}
    </div>
    {% if hidden_count > 0 %}
    <button class="updates-toggle" onclick="var el=document.getElementById('updates-more'); var hidden=el.hasAttribute('hidden'); el.toggleAttribute('hidden'); this.textContent=hidden?'Show fewer ↑':'Show all ↓'">Show all ↓</button>
    {% endif %}
  </div>
</section>

<section class="home-section alt-bg">
  <div class="container">
    <div class="section-header">
      <h2>Upcoming Seminars</h2>
      <a href="/seminar/">View all &rarr;</a>
    </div>
    <div class="seminar-full-list">
      {% assign upcoming = site.data.seminars.upcoming | slice: 0, 3 %}
      {% for talk in upcoming %}
      {% assign date_parts = talk.date | split: "-" %}
      {% assign month_num = date_parts[1] %}
      {% assign months = "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec" | split: "," %}
      {% assign month_index = month_num | minus: 1 %}
      {% assign month_name = months[month_index] %}
      <div class="card seminar-entry seminar-entry-upcoming">
        <div class="card-body d-flex gap-3">
          <div class="seminar-date flex-shrink-0">
            <span class="month">{{ month_name }}</span>
            <span class="day">{{ date_parts[2] }}</span>
            <span class="year">{{ date_parts[0] }}</span>
          </div>
          <div class="flex-grow-1" style="min-width:0">
            <h3 class="seminar-heading">{{ talk.title }}</h3>
            <p class="seminar-speaker-line"><span class="seminar-speaker">{{ talk.speaker }}</span>{% if talk.affiliation %}, {{ talk.affiliation }}{% endif %}</p>
            <p class="seminar-time">{{ talk.date | date: "%B %-d, %Y" }}{% if talk.time %}, {{ talk.time }}{% endif %}</p>
            {% if talk.livestream_url %}
            <div class="seminar-action-row">
              <a class="btn btn-sm btn-primary" href="{{ talk.livestream_url }}" target="_blank" rel="noopener"><i class="bi bi-broadcast me-1"></i>Livestream</a>
            </div>
            {% endif %}
          </div>
        </div>
      </div>
      {% endfor %}
    </div>
  </div>
</section>

<section class="home-section">
  <div class="container">
    <h2 class="mb-3">Connect</h2>
    <p>Join our mailing list for seminar announcements, watch past talks on YouTube, or attend our weekly seminar live.</p>
    <div class="d-flex flex-wrap gap-2 mt-3">
      <a href="{{ site.mailing_list }}" class="btn btn-primary" target="_blank" rel="noopener">Join Mailing List</a>
      <a href="{{ site.youtube_archive }}" class="btn btn-outline-primary" target="_blank" rel="noopener">YouTube Archive</a>
      <a href="mailto:{{ site.email }}" class="btn btn-outline-primary">Contact Us</a>
    </div>
  </div>
</section>
