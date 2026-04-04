
![Flyton Logo](fly-logo.png)

# Flyton

**Flyton** is a non-framework, Python based web development environment that generates HTML pages on the fly

[https://www.flyton.ai](https://www.flyton.ai)

## ✨ Key Features

- **No Framework**: Pure Python3. Simple, powerful, and stable.
- **Real-Time HTML Generation**: Server-side rendering using Python f-strings.
- **Zero Package Dependencies**: Native Python — no external libraries required.
- **Terminal + Browser Demo Ready**: See code come to life.
- **Component-Like Programming**: Code is modular and self-explanatory.
- **CGI Based**: Uses CGI scripts to connect browser ↔ apache ↔ Linux server.
- **Apache2 + Ubuntu**: Reliable, well-supported stack.
- **HTTPS**: Deploy via AWS with CloudFront or Load Balancer.
- **MySQL Recommended**: One unified access point with SQL best practices.
- **Managed Sessions**: Browser & server session support included.
- **UI tools**: Buttons and form parameters passing utility
- **Api**: Ready api mechanism for a dynamic web pages - with full support
- **base tables**: sql best practice records structure with ready made tables: users / sessions / logs 
- **database**: one point of tools to read and write to the database , secure and comfortable
- **Directory Structure**:
  - `server/`
  - `client/`

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
- fast learning of the tools

## 🚀 Code Example

```python
# hello.py
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



## Example 2:


```python


def page_top(data):
    ses = data["ses"]
    search = data["search"]
    meta   = data["meta"]
    return f"""
        <div class="categoryPage_top">
            <div class="categoryPage_topTitle">display {meta["total"]} products</div>
            
            {page_tags(search,meta)}
            
            <div class="categoryPage_topLeft">
                <div class="categoryPage_topSort">
                    <label for="categorySort">sort by</label>
                    <div class="comboHolder">
                    <select id="categorySort" onchange=cat_resort(this.value)>
                        <option value=pop>Rating</option>
                        <option value=sortl>Price low</option>
                        <option value=sorth>Price high</option>
                    </select></div>
                </div>
                <div class="categoryPage_mobileToggleFilter"><a style="cursor: pointer;" class="hasFilters" aria-controls="categoryPage_filterPanel" role="button">filters</a></div>
            </div>
        </div>           
    """

```


## Example 3: Button

In Flyton, buttons are created with `kicbutton()` — a utility that builds a `<button>` tag wired to the Flyton navigation system. The button navigates to a page, passing the session and any extra parameters automatically.

```python
from tools.kicutil import *

def my_page(data):
    ses = data["ses"]

    # Render the JS handler once (before any buttons on the page)
    print(kicbutton0())

    print(f"""
    <html>
    <body>
        <h1>Welcome</h1>

        <!-- Simple button: navigates to "dashboard" page -->
        {kicbutton("dashboard", ses, "Go to Dashboard", "btn btn-primary")}

        <!-- Button with extra parameters passed in the URL -->
        {kicbutton("product", ses, "View Product", "btn btn-secondary", {{"id": "42"}})}
    </body>
    </html>
    """)
```

- `kicbutton(page, ses, title, cls, more)` — generates a `<button>` that calls `kic_run_but()` on click.
- `kicbutton0()` — outputs the required `<script>` block; call it once per page before any buttons.
- `more` — a dict of extra URL parameters (e.g. `{{"id": "42"}}`).

> Flyton: Write in Python. Fly on the web.
