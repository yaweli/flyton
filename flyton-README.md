
# Flyton

**Flyton** is a non-framework, Python3-based web development environment that generates HTML pages on the fly — just like old-school PHP.

## ✨ Key Features

- **No Framework**: Pure Python3. Simple, powerful, and stable.
- **Real-Time HTML Generation**: Server-side rendering using Python f-strings.
- **Zero Package Dependencies**: Native Python — no external libraries required.
- **Terminal + Browser Demo Ready**: See code come to life.
- **Component-Like Programming**: Code is modular and self-explanatory.
- **CGI Based**: Uses CGI scripts to connect browser ↔ Linux server.
- **Apache2 + Ubuntu**: Reliable, well-supported stack.
- **HTTPS Ready**: Deploy via AWS with CloudFront or Load Balancer.
- **MySQL Recommended**: One unified access point with SQL best practices.
- **Managed Sessions**: Browser & server session support included.
- **Directory Structure**:
  - `server/`
  - `client/`
  - `admin/`

## 🛠 Tools & Methodologies

- Web components: buttons, cards, links, etc.
- Bootstrap-friendly (for UI/UX flexibility).
- Built-in client-server API manager.
- Static page support.
- Readable, maintainable code.
- Multi-app support from one server.

## 🤖 Philosophy

Flyton prioritizes:
- Clean, reusable code.
- Developer-friendly standards.
- Future-proof stability — 100% backward compatibility.

## 🚀 Code Example

```python
# hello.py — Flyton CGI script
print("Content-Type: text/html\n")
name = "World"
print(f""" 
<html>
<head><title>Hello Flyton</title></head>
<body>
<h1>Hello {name}!</h1>
<p>This page was generated using Python f-strings in real-time.</p>
</body>
</html>
""")
```

## 🎬 Animation Suggestion

A split-screen showing:
1. Terminal running the Python CGI script.
2. Browser displaying the resulting HTML.

---

> Flyton: Write in Python. Fly on the web.
