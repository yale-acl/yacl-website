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
          <div class="update-meta">
            <div class="update-date">
              <span class="update-date-month">{{ update.date | date: "%b" }}</span>
              <span class="update-date-day">{{ update.date | date: "%-d" }}</span>
              <span class="update-date-year">{{ update.date | date: "%Y" }}</span>
            </div>
          </div>
          <span class="update-body"><span class="update-text">{% if update.url %}<a href="{{ update.url }}">{{ update.text | markdownify | remove: '<p>' | remove: '</p>' | strip }}</a>{% else %}{{ update.text | markdownify | remove: '<p>' | remove: '</p>' | strip }}{% endif %}</span></span>
          {% if update.tag %}<span class="update-tag update-tag--{{ update.tag }}">{{ update.tag }}</span>{% endif %}
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
        <p>To be notified about future talks, register to our <a href="{{ site.mailing_list }}" target="_blank" rel="noopener">mailing list</a> and <a href="{{ site.calendar_embed }}" target="_blank" rel="noopener">calendar</a>.
        To view past talks, check our <a href="{{ site.youtube_archive }}" target="_blank" rel="noopener">YouTube</a>. Interested in giving a talk? Reach out!
        </p>
    </div>
    <div class="seminar-full-list">
      {% assign upcoming = site.data.seminars.upcoming | slice: 0, 3 %}
      {% for talk in upcoming %}
      <details class="card seminar-entry seminar-entry-upcoming">
        <summary class="card-body seminar-entry-summary">
          <div class="d-flex gap-3">
            <div class="seminar-date flex-shrink-0">
              <span class="month">{{ talk.date | date: "%b" }}</span>
              <span class="day">{{ talk.date | date: "%d" }}</span>
              <span class="year">{{ talk.date | date: "%Y" }}</span>
            </div>
            <div class="flex-grow-1" style="min-width:0">
              <h3 class="seminar-heading">{{ talk.title }}</h3>
              <p class="seminar-speaker-line"><span class="seminar-speaker">{{ talk.speaker }}</span>{% if talk.affiliation %}, {{ talk.affiliation }}{% endif %}</p>
              <p class="seminar-time">{{ talk.date | date: "%B %-d, %Y" }}{% if talk.time %}, {{ talk.time }}{% endif %}</p>
              <div class="seminar-action-row">
                {% if talk.livestream_url %}<a class="btn btn-sm seminar-btn seminar-btn-livestream" href="{{ talk.livestream_url }}" target="_blank" rel="noopener"><i class="bi bi-broadcast me-1"></i>Livestream</a>{% endif %}
                {% if talk.video_url %}<a class="btn btn-sm seminar-btn seminar-btn-video" href="{{ talk.video_url }}" target="_blank" rel="noopener"><i class="bi bi-play-circle me-1"></i>Video</a>{% endif %}
                <span class="btn btn-sm seminar-btn seminar-btn-details seminar-toggle" aria-hidden="true">
                  <span class="seminar-toggle-label seminar-toggle-label-open"><i class="bi bi-chevron-down me-1"></i>Details</span>
                  <span class="seminar-toggle-label seminar-toggle-label-close"><i class="bi bi-chevron-up me-1"></i>Details</span>
                </span>
              </div>
            </div>
          </div>
        </summary>
        <div class="card-body border-top seminar-entry-body">
          {% if talk.abstract %}<p class="seminar-detail"><strong>Abstract:</strong> {{ talk.abstract }}</p>{% endif %}
          {% if talk.bio %}<p class="seminar-detail"><strong>Bio:</strong> {{ talk.bio }}</p>{% endif %}
        </div>
      </details>
      {% endfor %}
    </div>

    <a class="d-inline-block mt-2" href="/seminar/">View more upcoming talks &rarr;</a>
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
