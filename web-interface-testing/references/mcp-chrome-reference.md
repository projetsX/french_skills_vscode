# MCP Google Chrome DevTools - Référence Rapide

## A propos du MCP

Le **Model Context Protocol (MCP)** de Google Chrome DevTools fournit une interface pour tester et analyser les pages web programmatically.

📖 **Documentation officielle complète**: 
https://raw.githubusercontent.com/ChromeDevTools/chrome-devtools-mcp/refs/heads/main/README.md

## Outils Principaux

### Navigation & Pages

| Outil | Usage | Exemple |
|-------|-------|---------|
| `mcp_chromedevtool_new_page` | Ouvrir une nouvelle page | `new_page(url="http://localhost:5173")` |
| `mcp_chromedevtool_navigate_page` | Aller à une URL | `navigate_page(type="url", url="http://site.loc/page")` |
| `mcp_chromedevtool_select_page` | Sélectionner une page active | `select_page(pageId=1)` |
| `mcp_chromedevtool_list_pages` | Lister pages ouvertes | `list_pages()` |

### Capture & Inspection

| Outil | Usage | Exemple |
|-------|-------|---------|
| `mcp_chromedevtool_take_screenshot` | Screenshot PNG/JPEG | `take_screenshot(format="png", fullPage=true)` |
| `mcp_chromedevtool_take_snapshot` | Snapshot DOM/a11y | `take_snapshot(verbose=true)` |
| `mcp_chromedevtool_take_memory_snapshot` | Dump mémoire | `take_memory_snapshot(filePath="dump.heapsnapshot")` |

### Interaction

| Outil | Usage | Exemple |
|-------|-------|---------|
| `mcp_chromedevtool_click` | Cliquer sur élément | `click(uid="element-123")` |
| `mcp_chromedevtool_fill` | Remplir input | `fill(uid="input-1", value="texte")` |
| `mcp_chromedevtool_fill_form` | Remplir plusieurs inputs | `fill_form(elements=[{"uid":"in1","value":"val1"},...])` |
| `mcp_chromedevtool_press_key` | Appuyer sur key | `press_key(key="Enter")` ou `press_key(key="Control+A")` |
| `mcp_chromedevtool_type_text` | Taper du texte | `type_text(text="hello")` |

### Console & Network

| Outil | Usage | Exemple |
|-------|-------|---------|
| `mcp_chromedevtool_list_console_messages` | Récupérer logs/errors | `list_console_messages(types=['error','warn'])` |
| `mcp_chromedevtool_get_console_message` | Détails d'un message | `get_console_message(msgid=5)` |
| `mcp_chromedevtool_list_network_requests` | Requêtes HTTP | `list_network_requests(resourceTypes=['xhr','fetch'])` |
| `mcp_chromedevtool_get_network_request` | Détails d'une requête | `get_network_request(reqid=10)` |

### Performance & Debugging

| Outil | Usage | Exemple |
|-------|-------|---------|
| `mcp_chromedevtool_performance_start_trace` | Démarrer audit perf | `performance_start_trace(reload=true, autoStop=true)` |
| `mcp_chromedevtool_performance_stop_trace` | Arrêter audit | `performance_stop_trace()` |
| `mcp_chromedevtool_performance_analyze_insight` | Analyser insight | `performance_analyze_insight(insightSetId="set1", insightName="LCPBreakdown")` |

### Viewport & Responsive

| Outil | Usage | Exemple |
|-------|-------|---------|
| `mcp_chromedevtool_resize_page` | Redimensionner | `resize_page(width=375, height=812)` |
| `mcp_chromedevtool_emulate` | Émuler device | `emulate(viewport={...}, colorScheme="dark", networkConditions="Slow 3G")` |

## Cas Courants

### ✅ Tester un formulaire

```python
# 1. Prendre snapshot pour voir les inputs
snapshot = take_snapshot(verbose=true)

# 2. Remplir les inputs
fill(uid="email-field", value="test@example.com")
fill(uid="password-field", value="SecurePass123")

# 3. Cliquer le bouton submit
click(uid="submit-button")

# 4. Vérifier la réaction (pas d'erreur, redirection, etc.)
new_snapshot = take_snapshot()
messages = list_console_messages(types=['error'])
```

### ✅ Tester le responsive

```python
# Desktop
resize_page(1920, 1080)
screenshot_desktop = take_screenshot(format="png")

# Mobile
resize_page(375, 812)
screenshot_mobile = take_screenshot(format="png")

# Tablet
resize_page(768, 1024)
screenshot_tablet = take_screenshot(format="png")
```

### ✅ Audit performance

```python
navigate_page(type="url", url="https://target.com")

# Démarrer trace (recharge page)
performance_start_trace(reload=true, autoStop=true)

# Récupérer Core Web Vitals, CPU/RAM info
insights = performance_analyze_insight(insightSetId="main", insightName="DocumentLatency")
```

### ✅ Vérifier accessibilité

```python
# Snapshot en mode verbose (accessible tree)
tree = take_snapshot(verbose=true)

# Chercher des img sans alt, labels sans for, etc.
# Analyser manuellement le tree JSON
```

## Résolutions d'Écran Communes

| Device | Largeur | Hauteur | Notes |
|--------|---------|---------|-------|
| Desktop XS | 1024 | 768 | Vieux moniteurs |
| Desktop | 1920 | 1080 | Standard |
| Desktop XL | 2560 | 1440 | 2K |
| Tablet | 768 | 1024 | iPad |
| Mobile L | 480 | 854 | Grands mobiles |
| Mobile M | 414 | 896 | iPhone 11 |
| Mobile S | 375 | 812 | iPhone SE |
| Mobile XS | 360 | 800 | Budget phones |

## Console Message Types

```
log      — Information standard
debug    — Debug info
info     — Info-level messages
warn     — Warnings (non-bloquant)
error    — Erreurs (bloquant)
trace    — Stack traces
table    — Formatted tables
assert   — Assertion failures
profile  — Performance profiling
```

## Network Resource Types

```
document      — Page HTML
stylesheet    — CSS files
image         — Images (PNG, JPG, SVG, etc.)
media         — Audio/video
font          — Font files
script        — JavaScript files
xhr           — XMLHttpRequest
fetch         — Fetch API calls
websocket     — WebSocket connections
manifest      — Web app manifest
```

## Emulations Disponibles

### Network Throttling
```
"No emulation"   — Normal
"Offline"        — Sans connexion
"Slow 3G"        — 400 kbps
"Fast 3G"        — 1.6 mbps
"Slow 4G"        — 4 mbps
"Fast 4G"        — 20 mbps
```

### Color Scheme
```
"auto"   — Suivre système
"dark"   — Mode sombre
"light"  — Mode clair
```

## Workflow Typique d'Audit

1. Ouvrir page: `new_page(url="...")`
2. Prendre snapshot: `take_snapshot(verbose=true)`
3. Tester inputs: `fill()`, `click()`, vérifier `list_console_messages()`
4. Tester responsive: `resize_page()` à (1920, 1080), (768, 1024), (375, 812)
5. Analyser perf: `performance_start_trace()` → `performance_analyze_insight()`
6. Reporter findings

---

**Mise à jour**: À jour au 2025-03-10  
**Source**: https://github.com/ChromeDevTools/chrome-devtools-mcp
