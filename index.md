---
layout: default
title: Home
---

<section class="home-hero">
  <div class="container">
    <img src="/assets/images/yacl_logo.png" alt="YACL Logo" class="hero-logo">
    <h1>Yale Applied Cryptography Laboratory</h1>
    <p class="tagline">We are a group of researchers at Yale working on applied cryptography.</p>
    <div class="hero-actions">
      <a href="/people/" class="btn btn-primary">Our Team</a>
      <a href="/seminar/" class="btn btn-outline">Weekly Seminar</a>
    </div>
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
          <span class="update-date">{{ update.date | date: "%b %-d, %Y" }}</span>
          <span class="update-body">{% if update.tag %}<span class="update-tag update-tag--{{ update.tag }}">{{ update.tag }}</span> {% endif %}<span class="update-text">{% if update.url %}<a href="{{ update.url }}">{{ update.text }}</a>{% else %}{{ update.text }}{% endif %}</span></span>
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
    <div class="seminar-list">
      {% assign upcoming = site.data.seminars.upcoming | slice: 0, 3 %}
      {% for talk in upcoming %}
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
          <p class="seminar-meta"><strong>{{ talk.speaker }}</strong> &mdash; {{ talk.affiliation }}</p>
          <p class="seminar-time">{{ talk.time }}</p>
        </div>
      </div>
      {% endfor %}
    </div>
  </div>
</section>

<section class="home-section">
  <div class="container">
    <div class="section-header">
      <h2>Connect</h2>
    </div>
    <p>Join our mailing list for seminar announcements, watch past talks on YouTube, or attend our weekly seminar live.</p>
    <div class="hero-actions" style="justify-content:flex-start; margin-top:1rem;">
      <a href="{{ site.mailing_list }}" class="btn btn-primary" target="_blank" rel="noopener">Join Mailing List</a>
      <a href="{{ site.youtube_archive }}" class="btn btn-outline" style="border-color:#286dc0;color:#286dc0;" target="_blank" rel="noopener">YouTube Archive</a>
      <a href="mailto:{{ site.email }}" class="btn btn-outline" style="border-color:#286dc0;color:#286dc0;">Contact Us</a>
    </div>
  </div>
</section>
