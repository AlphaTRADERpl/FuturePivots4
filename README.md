# Future Pivots 4

> Daily, weekly, and monthly pivot points for MetaTrader 4 — with full support / resistance level projections and clean multi-timeframe overlay.

![Future Pivots 5 on a live chart](https://github.com/AlphaTRADERpl/FuturePivots5/blob/main/pivots.png?raw=true)

[![License: BSD-3-Clause](https://img.shields.io/badge/license-BSD--3--Clause-blue?style=flat-square)](LICENSE)
[![Platform: MetaTrader 4](https://img.shields.io/badge/platform-MT4-orange?style=flat-square)](https://www.metatrader4.com)
[![Download](https://img.shields.io/badge/download-latest%20release-success?style=flat-square)](https://github.com/AlphaTRADERpl/FuturePivots4/releases/latest)

---

## What it does

A pivot point is a price level calculated from the previous period's high, low, and close. It marks where institutional traders historically defend or attack price — areas of support, resistance, and reward-to-risk skew.

**Future Pivots 4** draws:

- **Daily, weekly, and monthly pivots** simultaneously on any chart timeframe
- **Three full support/resistance projections** per timeframe (S1/S2/S3 and R1/R2/R3)
- **Color-coded levels** so weekly/monthly dominance is visible at a glance
- **Mid-pivot levels** between PP/S1/R1 — the lines where most reversals actually happen, missed by stock pivot indicators

Trading above the daily pivot = bullish bias for the session. Trading below = bearish. Levels broken with conviction become next-period S/R. Standard Wyckoff confluence material.

---

## Install

1. Download the latest `FuturePivots.mq4` from [Releases](https://github.com/AlphaTRADERpl/FuturePivots4/releases/latest)
2. Open MetaTrader 4 → `File → Open Data Folder`
3. Drop the file into `MQL4/Indicators/`
4. Open MetaEditor (F4 in MT4, or `Tools → MetaQuotes Language Editor`)
5. Open `FuturePivots.mq4` from `Indicators/` → press F7 to compile → output `.ex4` lands next to source
6. Back in MT4, right-click in `Navigator → Refresh`
7. Drag **Future Pivots** from `Navigator → Indicators` onto any chart

> This release ships source only — MT4 doesn't auto-compile dropped files. MetaEditor is bundled with every MT4 broker install, so the F7 compile step takes 2 seconds.

---

## Settings <!-- TODO:setting names — adjust if your inputs differ -->

| Parameter | Default | Description |
|---|---|---|
| `ShowDaily` | `true` | Toggle daily pivots on/off |
| `ShowWeekly` | `true` | Toggle weekly pivots on/off |
| `ShowMonthly` | `true` | Toggle monthly pivots on/off |
| `ShowMidLevels` | `true` | Render mid-pivot levels (M0-M5) — high-reversal zones |
| `DailyColor` | `clrAqua` | Daily pivot line color |
| `WeeklyColor` | `clrOrange` | Weekly pivot line color |
| `MonthlyColor` | `clrMagenta` | Monthly pivot line color |
| `LineWidth` | `1` | Line thickness in pixels (try `2` for chart shots) |
| `LineStyle` | `STYLE_DOT` | `STYLE_SOLID` / `STYLE_DOT` / `STYLE_DASH` |
| `LabelText` | `true` | Draw level labels (PP, R1, R2, S1, S2) at right edge |

All settings are editable per chart via right-click → `Indicators List → Future Pivots 4 → Properties`.

---

## Demo

<!-- TODO:gif demo — record a 60-90s screencast showing:
     1. Drag indicator onto chart
     2. Settings panel
     3. Switch timeframes — pivots stay anchored
     4. Show a setup near pivot (price reaction at S1 or R1)
     Save as gif, drop in ./assets/ and reference here. -->

*Screencast coming soon — for now, see [live use on alphatrader.pl](https://www.alphatrader.pl/trader/journey/goat) where the MT5 sibling of this indicator runs on real funded account streams.*

---

## How I use it

This indicator is the foundation of my intraday Wyckoff workflow:

- **Phase D / E setups** — pivot levels mark where Spring or LPS rejection candles trigger
- **Confluence stacking** — daily pivot + weekly S1 + Wyckoff trading range edge = high-conviction zone
- **Risk anchoring** — stop loss beyond the next pivot level, target the opposite side. R:R writes itself
- **Session bias** — first 30min of London session price relative to daily PP tells you the day's intent

Full methodology in the [free Academy lesson on pivots](https://www.alphatrader.pl/trader/education) (33 lessons total, no email gate).

---

## MT4 vs MT5

This is the **MT4 version**. If you're on MetaTrader 5, grab the optimized MQL5 build instead:

→ **[Future Pivots 5](https://github.com/AlphaTRADERpl/FuturePivots5)** — same logic, native MQL5, better performance on multi-symbol scans.

MT4 is officially in maintenance mode (no new features from MetaQuotes since 2019). This indicator is kept compatible as long as MT4 builds run — but the active development line is MT5.

---

## Limitations

- Pivots are **lagging in choppy regimes** — they shine in trending sessions
- **Weekend gaps** can stretch weekly pivots wider than usual — confirm with volume
- Designed for **forex, indices, metals**. Crypto pivots calculated from previous *day* (not 24h window) — works but less reliable than on regulated markets
- **MT4 platform constraints**: no native ChartPeriod() granularities below M1, so sub-minute pivots are not supported

---

## Related tools

If Future Pivots 4 is useful, the rest of the AlphaTRADER stack might be too:

- **[Alpha Trade Panel](https://www.alphatrader.pl/trader/tools)** — manual execution panel with risk-based sizing
- **[Free 33-lesson Wyckoff Academy](https://www.alphatrader.pl/trader/education)** — the framework these tools are built around

Premium tools unlock with the **[Patreon Neural tier](https://www.patreon.com/AlphaTRADERpl)** (also includes live AI signal scanner + premium MT5 indicators bundle).

---

## License

[BSD-3-Clause](LICENSE) — free to use, modify, redistribute. Commercial use OK. Attribution required.

---

## Support

- **Bug reports / feature requests** → [Issues](https://github.com/AlphaTRADERpl/FuturePivots4/issues)
- **Trading methodology questions** → [Academy](https://www.alphatrader.pl/trader/education) or [Telegram](https://t.me/alphatrader_ideas)
- **Like the tool?** → [Sponsor on Patreon](https://www.patreon.com/AlphaTRADERpl) — keeps me writing free indicators

---

<sub>Built by [AlphaTRADER](https://www.alphatrader.pl) — Wyckoff trader running real funded prop accounts, publishing the tools and the journey at [alphatrader.pl/journey](https://www.alphatrader.pl/journey/goat).</sub>
