# Pixel 🚀

**Pixel** is a personalized, campus-first discovery and collaboration platform designed to help students stay informed, connected, and opportunity-ready. It centralizes events, hackathons, club activities, and collaboration opportunities into one intelligent hub tailored to each student.

---

## 📌 Table of Contents

* [Overview](#overview)
* [Problem Statement](#problem-statement)
* [Solution](#solution)
* [Key Features](#key-features)
* [Product Scope](#product-scope)
* [Tech Stack](#tech-stack)
* [System Architecture](#system-architecture)
* [Deployment](#deployment)
* [Costing & Infrastructure Estimate](#costing--infrastructure-estimate)
* [Roadmap](#roadmap)
* [Security & Privacy](#security--privacy)
* [Target Users](#target-users)
* [Business Model (Planned)](#business-model-planned)
* [Status](#status)
* [Contributing](#contributing)

---

## 🧠 Overview

Students often miss out on valuable campus opportunities because information is scattered across emails, WhatsApp groups, notice boards, and social media. Pixel solves this by acting as a **single source of truth for campus life**, delivering personalized and relevant updates directly to students.

Pixel is built with a startup-first mindset: scalable, modular, and ready to evolve into a full campus ecosystem platform.

---

## ❗ Problem Statement

Students commonly face:

* Missed events and deadlines due to fragmented communication
* Difficulty finding the right teammates for hackathons and projects
* Information overload with low relevance
* Lack of a structured campus-wide discovery platform

---

## ✅ Solution

Pixel provides:

* A **centralized feed** of campus events and opportunities
* **Personalized recommendations** based on interests and skills
* A **collaboration and teammate-matching system**
* Event tracking, reminders, and deadline management

All within a clean, campus-centric interface.

---

## 🌟 Key Features

### 📢 Centralized Event & Opportunity Feed

* Campus events
* Hackathons
* Workshops & competitions
* Club activities

> Eliminates dependency on scattered communication channels.

### 🎯 Personalized Recommendations

Recommendations based on:

* User interests
* Skill set & tech stack
* Past interactions

> Reduces noise and increases relevance.

### 👥 Teammate & Collaboration Finder

* Find teammates for hackathons, projects, and competitions
* Matching based on skills, interests, and availability

### 📅 Event Tracking & Reminders

* Save events
* Track deadlines
* Reminder notifications (planned)

### 🏫 Campus-Centric Design

* Built specifically for universities
* Supports students, clubs, faculty, and organizers

### 🧭 Clean & Intuitive UI

* Minimal and modern design
* Easy navigation across events, teams, and profiles

---

## 📦 Product Scope

**In Scope (Current / MVP):**

* User authentication
* Event listing & discovery
* Personalized feed logic (basic)
* Profile creation
* Early access web deployment

**Out of Scope (Planned):**

* Advanced AI-driven recommendations
* In-app chat
* Admin dashboards for colleges
* Analytics for organizers

---

## 🛠 Tech Stack

### 📱 Frontend

* **Flutter** – Cross-platform mobile development
* Responsive UI for Android & iOS

### 🔐 Backend & Database

* **Supabase**

  * Authentication (Email / OAuth)
  * PostgreSQL database
  * Row-Level Security (RLS)
  * Real-time subscriptions

### ☁️ Cloud & Infrastructure

* **AWS**

  * Media storage (S3)
  * Scalable backend services

### 🚀 Deployment

* **Vercel** – Early access web deployment

---

## 🧱 System Architecture

```
Flutter App / Web
        |
        v
Supabase Auth & API Layer
        |
        v
PostgreSQL Database
        |
        v
AWS (Media & Infrastructure)
```

---

## 💰 Costing & Infrastructure Estimate (Monthly)

> *Early-stage / MVP-level estimates*

### 🗄 Backend (Supabase)

* Free tier (initial users): ₹0
* Pro tier (scaling): ~₹2,000 – ₹3,000

### ☁️ AWS

* S3 Storage (media assets): ₹500 – ₹1,000
* Misc services (logs, bandwidth): ₹500

### 🌐 Deployment (Vercel)

* Hobby / Free tier: ₹0
* Pro (if needed): ~₹1,500

### 📊 Total Estimated Monthly Cost

**₹2,000 – ₹6,000** (depending on scale)

---

## 🗺 Roadmap

### Phase 1 – MVP (Current)

* Core discovery platform
* Early access web version

### Phase 2 – Mobile App

* Full Flutter mobile app
* Push notifications

### Phase 3 – Intelligence Layer

* AI-based recommendations
* Smart teammate matching

### Phase 4 – Campus Partnerships

* Admin dashboards for colleges
* Verified events & analytics

---

## 🔐 Security & Privacy

* Secure authentication via Supabase
* Row-Level Security for data isolation
* Minimal data collection
* Privacy-first design approach

---

## 🎓 Target Users

* University students
* College clubs & societies
* Hackathon organizers
* Faculty & student coordinators

---

## 💼 Business Model (Planned)

* Freemium for students
* Subscription for colleges & organizers
* Sponsored events & featured listings
* Campus analytics dashboards

---

## 🚧 Status

* 🧪 Early Access
* Actively under development
* UI and features evolving based on feedback

🌐 **Live Demo:** [https://pixelweb-alpha.vercel.app/](https://pixelweb-alpha.vercel.app/)

---

## 🤝 Contributing

Contributions, feedback, and ideas are welcome.

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Open a pull request

---

## 📄 License

This project is currently under a **proprietary / early-stage license**. Licensing details will be finalized as the product evolves.
