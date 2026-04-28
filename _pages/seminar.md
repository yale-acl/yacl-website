---
title: Seminar
subtitle: Weekly cryptography and security talks — Fridays at 11am ET
layout: page
permalink: /seminar/
---

<div class="">
  <p>To be notified about future talks, register to our <a href="{{ site.mailing_list }}" target="_blank" rel="noopener">mailing list</a> and <a href="{{ site.calendar_embed }}" target="_blank" rel="noopener">calendar</a>.
  To view past talks, check our <a href="{{ site.youtube_archive }}" target="_blank" rel="noopener">YouTube</a>. Interested in giving a talk? Reach out!</p>
</div>

<h2>Upcoming Talks</h2>
<div class="seminar-full-list">
  {% for talk in site.data.seminars.upcoming %}
  <details class="card seminar-entry seminar-entry-upcoming">
    <summary class="card-body seminar-entry-summary">
      <div class="d-flex gap-3">
        {% if talk.photo %}
        <img class="seminar-speaker-photo flex-shrink-0" src="{{ talk.photo }}" alt="{{ talk.speaker }}">
        {% else %}
        <div class="seminar-date flex-shrink-0">
          <span class="month">{{ talk.date | date: "%b" }}</span>
          <span class="day">{{ talk.date | date: "%d" }}</span>
          <span class="year">{{ talk.date | date: "%Y" }}</span>
        </div>
        {% endif %}
        <div class="flex-grow-1" style="min-width:0">
          <h3 class="seminar-heading">{{ talk.title }}</h3>
          <p class="seminar-speaker-line"><span class="seminar-speaker">{{ talk.speaker }}</span>{% if talk.affiliation %}, {{ talk.affiliation }}{% endif %}</p>
          <p class="seminar-time">{{ talk.date | date: "%B %-d, %Y" }}{% if talk.time %}, {{ talk.time }}{% endif %}</p>
          <div class="seminar-action-row">
            {% if talk.livestream_url %}
            <a class="btn btn-sm seminar-btn seminar-btn-livestream" href="{{ talk.livestream_url }}" target="_blank" rel="noopener"><i class="bi bi-broadcast me-1"></i>Livestream</a>
            {% endif %}
            {% if talk.video_url %}
            <a class="btn btn-sm seminar-btn seminar-btn-video" href="{{ talk.video_url }}" target="_blank" rel="noopener"><i class="bi bi-play-circle me-1"></i>Video</a>
            {% endif %}
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
      {% if talk.links %}
      <div class="seminar-links">
        <strong>Links:</strong>
        <ul>
          {% for link in talk.links %}
          <li><a href="{{ link }}" target="_blank" rel="noopener">{{ link }}</a></li>
          {% endfor %}
        </ul>
      </div>
      {% endif %}
    </div>
  </details>
  {% endfor %}
</div>

<h2>Past Talks</h2>

<div class="seminar-full-list">
  {% for talk in site.data.seminars.past %}
  <details class="card seminar-entry seminar-entry-past">
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
          <p class="seminar-time">{{ talk.date | date: "%B %-d, %Y" }}</p>
          <div class="seminar-action-row">
            {% if talk.livestream_url %}
            <a class="btn btn-sm seminar-btn seminar-btn-livestream" href="{{ talk.livestream_url }}" target="_blank" rel="noopener">Livestream</a>
            {% endif %}
            {% if talk.video_url %}
            <a class="btn btn-sm seminar-btn seminar-btn-video" href="{{ talk.video_url }}" target="_blank" rel="noopener"><i class="bi bi-play-circle me-1"></i>Video</a>
            {% endif %}
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
      {% if talk.links %}
      <div class="seminar-links">
        <strong>Links:</strong>
        <ul>
          {% for link in talk.links %}
          <li><a href="{{ link }}" target="_blank" rel="noopener">{{ link }}</a></li>
          {% endfor %}
        </ul>
      </div>
      {% endif %}
    </div>
  </details>
  {% endfor %}
</div>

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
