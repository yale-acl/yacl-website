---
title: People
subtitle: Faculty, students, and researchers at YACL
permalink: /people/
---

<div class="people-section">
  <h2>Faculty</h2>
  <div class="people-list people-list-wide">
    {% for person in site.data.people.faculty %}
    <article class="person-row person-row-featured">
      <img class="person-photo person-photo-large" src="{{ person.photo | default: site.data.people.placeholder }}" alt="{{ person.name }}">
      <div class="person-copy">
        <h3>{% if person.url and person.url != "" %}<a href="{{ person.url }}">{{ person.name }}</a>{% else %}{{ person.name }}{% endif %}</h3>
        <p class="person-role">{{ person.role }}</p>
        {% if person.email or person.url %}
        <p class="person-links">
          {% if person.email %}<a href="mailto:{{ person.email }}">Email</a>{% endif %}
          {% if person.email and person.url %}<span class="person-links-sep">|</span>{% endif %}
          {% if person.url %}<a href="{{ person.url }}" target="_blank" rel="noopener">Website</a>{% endif %}
        </p>
        {% endif %}
        {% if person.research %}<p class="person-research"><strong>Research:</strong> {{ person.research }}</p>{% endif %}
      </div>
    </article>
    {% endfor %}
  </div>
</div>


<div class="people-section">
  <h2>Postdoctoral Researchers</h2>
  <div class="people-list">
    {% for person in site.data.people.postdocs %}
    <article class="person-row person-row-featured">
      <img class="person-photo person-photo-large" src="{{ person.photo | default: site.data.people.placeholder }}" alt="{{ person.name }}">
      <div class="person-copy">
        <h3>{{ person.name }}</h3>
        {% if person.email or person.url %}
        <p class="person-links">
          {% if person.email %}<a href="mailto:{{ person.email }}">Email</a>{% endif %}
          {% if person.email and person.url %}<span class="person-links-sep">|</span>{% endif %}
          {% if person.url %}<a href="{{ person.url }}" target="_blank" rel="noopener">Website</a>{% endif %}
        </p>
        {% endif %}
        {% if person.research %}<p class="person-research"><strong>Research:</strong> {{ person.research }}</p>{% endif %}
      </div>
    </article>
    {% endfor %}
  </div>
</div>

<div class="people-section">
  <h2>PhD Students</h2>
  <div class="people-list">
    {% for person in site.data.people.phd_students %}
    <article class="person-row person-row-featured">
      <img class="person-photo person-photo-large" src="{{ person.photo | default: site.data.people.placeholder }}" alt="{{ person.name }}">
      <div class="person-copy">
        <h3>{{ person.name }}</h3>
        {% if person.email or person.url %}
        <p class="person-links">
          {% if person.email %}<a href="mailto:{{ person.email }}">Email</a>{% endif %}
          {% if person.email and person.url %}<span class="person-links-sep">|</span>{% endif %}
          {% if person.url %}<a href="{{ person.url }}" target="_blank" rel="noopener">Website</a>{% endif %}
        </p>
        {% endif %}
        {% if person.research %}<p class="person-research"><strong>Research:</strong> {{ person.research }}</p>{% endif %}
      </div>
    </article>
    {% endfor %}
  </div>
</div>

<div class="people-section">
  <h2>Alumni (Visitors)</h2>
  <div class="people-list">
    {% for person in site.data.people.alumni_visitors %}
    <article class="person-row person-row-featured">
      <img class="person-photo person-photo-large" src="{{ person.photo | default: site.data.people.placeholder }}" alt="{{ person.name }}">
      <div class="person-copy">
        <h3>{{ person.name }}</h3>
        {% if person.role %}<p class="member-role">{{ person.role }}</p>{% endif %}
        {% if person.email or person.url %}
        <p class="person-links">
          {% if person.email %}<a href="mailto:{{ person.email }}">Email</a>{% endif %}
          {% if person.email and person.url %}<span class="person-links-sep">|</span>{% endif %}
          {% if person.url %}<a href="{{ person.url }}" target="_blank" rel="noopener">Website</a>{% endif %}
        </p>
        {% endif %}
        {% if person.research %}<p class="person-research"><strong>Research:</strong> {{ person.research }}</p>{% endif %}
      </div>
    </article>
    {% endfor %}
  </div>
</div>

<div class="people-section">
  <h2>Alumni (Postdocs)</h2>
  <div class="people-list">
    {% for person in site.data.people.alumni_postdocs %}
    <article class="person-row person-row-featured">
      <img class="person-photo person-photo-large" src="{{ person.photo | default: site.data.people.placeholder }}" alt="{{ person.name }}">
      <div class="person-copy">
        <h3>{{ person.name }}</h3>
        {% if person.affiliation and person.affiliation != "" %}<p class="member-role">{{ person.affiliation }}</p>{% endif %}
        {% if person.email or person.url %}
        <p class="person-links">
          {% if person.email %}<a href="mailto:{{ person.email }}">Email</a>{% endif %}
          {% if person.email and person.url %}<span class="person-links-sep">|</span>{% endif %}
          {% if person.url %}<a href="{{ person.url }}" target="_blank" rel="noopener">Website</a>{% endif %}
        </p>
        {% endif %}
        {% if person.research %}<p class="person-research"><strong>Research:</strong> {{ person.research }}</p>{% endif %}
      </div>
    </article>
    {% endfor %}
  </div>
</div>

<div class="people-section">
  <h2>Alumni (Students)</h2>
  <div class="people-list">
    {% for person in site.data.people.alumni_phd_students %}
    <article class="person-row person-row-featured">
      <img class="person-photo person-photo-large" src="{{ person.photo | default: site.data.people.placeholder }}" alt="{{ person.name }}">
      <div class="person-copy">
        <h3>{{ person.name }}</h3>
        {% if person.affiliation and person.affiliation != "" %}<p class="member-role">{{ person.affiliation }}</p>{% endif %}
        {% if person.email or person.url %}
        <p class="person-links">
          {% if person.email %}<a href="mailto:{{ person.email }}">Email</a>{% endif %}
          {% if person.email and person.url %}<span class="person-links-sep">|</span>{% endif %}
          {% if person.url %}<a href="{{ person.url }}" target="_blank" rel="noopener">Website</a>{% endif %}
        </p>
        {% endif %}
        {% if person.research %}<p class="person-research"><strong>Research:</strong> {{ person.research }}</p>{% endif %}
      </div>
    </article>
    {% endfor %}
  </div>
</div>
