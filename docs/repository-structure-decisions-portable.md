# Переносимые решения по структуре репозитория

Этот документ фиксирует принятые решения по структуре документационного репозитория в переносимом виде.
Формат намеренно не DRR: правила можно взять как готовый шаблон для другого проекта.

## Оговорка для LLM при использовании как шаблона

Если этот файл используется как шаблон в другом репозитории:

- Не трактовать пути, ссылки и имена артефактов из этого файла как универсальную норму или внешний source-of-truth.
- Считать их локальными примерами реализации в текущем репозитории.
- Перед применением решений переназначить все ссылки на фактические артефакты целевого проекта.
- Технические ссылки на текущие артефакты (сессии, коммиты, DRR) использовать только как provenance-pin для проверки происхождения решений, а не как переносимую нормативную базу.

## Разделение DRR и правил по режимам работы репозитория (repo-oriented)

Это разделение относится к **операциям с самим репозиторием**, а не к онтологическому разрезу предметной области.

| Контур | Что регулирует | Типовые решения | Где фиксируется | Исполнение |
| --- | --- | --- | --- | --- |
| `Repo-Design-Time` | Структуру репозитория и правила работы с артефактами | где лежат каталоги, как именуем файлы, как ведем индексы/реестры, какие guardrails применяем | `docs/repository-structure-decisions-portable.md`, `AGENTS.md`, `docs/contributing.md`, `docs/style-guide.md`, `docs/work/drr/README.md` | Операции обслуживания репозитория: перемещения, переименования, обновление навигации, регистрация решений |
| `Repo-Run-Time` (transduction execution) | Выполнение пересчета содержательных артефактов | правила replay-ветки, состав входных carriers, декомпозиции и маппинги предметного контента | `docs/work/process-transduction/*.md`, materialized policy/spec carriers, `docs/work/drr/*.md` как provenance | `T24` (materialize) и затем целевые узлы replay-графа |

## Политика DRR для этих контуров

1. Для `Repo-Design-Time` решения должны быть материализованы в явных governance-документах репозитория (структура, конвенции, операции), чтобы ими можно было пользоваться без чтения всей истории DRR.
2. Для `Repo-Run-Time` решения по содержанию **не** подаются в replay напрямую из DRR; рабочая цепочка: `DRR -> materialize -> policy/spec carriers -> replay`.
3. Статус `superseded` обрабатывается через materialization: в исполняемые carriers переносится только актуальное (не superseded) решение; superseded DRR остаются provenance.
4. Если есть конфликтующие DRR и текущая materialization это не разрешает, пересчет должен останавливаться в `Unknown/abstain` до явного разрешения.

## Операции с репозиторием как документированный процесс

| Операция | Когда выполняется | Минимальный результат |
| --- | --- | --- |
| `ROP-01` Обновить структуру/правила репозитория | Изменили конвенцию путей, именования, ссылок, навигации | Обновлены governance-документы (`portable`, `AGENTS`, `contributing`, `style-guide`) |
| `ROP-02` Выполнить структурную миграцию | Перемещение/переименование файлов и каталогов | Обновлены ссылки и индексные страницы в том же change-set |
| `ROP-03` Зафиксировать semantic decision | Принято новое устойчивое решение | Создан DRR и обновлен `docs/work/drr/README.md` |
| `ROP-04` Материализовать content-решение для replay | DRR влияет на входы/политику трансдукции | Выполнен `T24`, обновлены policy/spec carriers |
| `ROP-05` Пересчитать трансдукционный контур | После `ROP-04` или изменения исполняемых carriers | Выполнены затронутые узлы replay-графа и checks |
| `ROP-06` Обработать supersede | DRR помечен как superseded или конфликтует с новым | Пере-материализация переносит только актуальное решение, старое остается в provenance |

## Базовый шаблон структуры

```text
docs/
  _sources/              # первичные carriers (брифы, исходные вводные)
  _generated/            # автогенерируемая навигация/служебные индексы
  work/                  # рабочие артефакты предметной области
    _internal/           # machine-readable source-of-truth
    process-transduction/# процессные/методические артефакты пересчета
    drr/                 # локальный реестр DRR (опционально для переноса)
```

## Реестр решений

| ID | Переносимое правило | Как применить в другом проекте | Реализация в этом репозитории | Подтверждение |
| --- | --- | --- | --- | --- |
| `RS-01` | Документация хранится под `docs/` и остается GitLab-readable. | Выделить единый корень документации и зафиксировать требования к Markdown-совместимости платформы. | `docs/` | [AGENTS.md](../AGENTS.md), [Contributing](contributing.md) |
| `RS-02` | Source-of-truth спецификация методологии хранится отдельно и не редактируется локально. | Зафиксировать read-only путь до внешней спецификации/норматива. | `refs/fpf/FPF-Spec.md` | [AGENTS.md](../AGENTS.md), [docs/index.md](index.md) |
| `RS-03` | Разделять рабочие страницы и первичные источники (`work` vs `_sources`). | Держать переработанные описания отдельно от исходных carrier-материалов. | `docs/work/` и `docs/_sources/` | [Contributing](contributing.md) |
| `RS-04` | Разделять human-view и machine-view артефакты. | Хранить публикации отдельно от внутренних схем/идентификаторов. | `docs/work/**` (human-view), `docs/work/_internal/**` (machine-view) | [DRR-0012](work/drr/drr-0012-devops-method-map-internal-vs-published.md), [DRR-0064](work/drr/drr-0064-publication-human-readable-naming-and-internal-machine-schema.md), [Style guide](style-guide.md) |
| `RS-05` | Выносить процессные артефакты (графы/методы пересчета) в отдельный каталог. | Отделить метод пересчета от предметного контента домена. | `docs/work/process-transduction/` | [DRR-0029](work/drr/drr-0029-devops-process-transduction-catalog-separation.md), [process-transduction/index.md](work/process-transduction/index.md) |
| `RS-06` | Крупные публикации делить на индекс и leaf-страницы по объектам. | Оставить стабильный entrypoint и вынести детали по отдельным файлам. | `docs/work/devops-service-method-maps.md` + `docs/work/devops-service-method-maps/*.md` | [DRR-0022](work/drr/drr-0022-devops-method-map-human-view-split.md) |
| `RS-07` | Для повторяемого расширения leaf-страниц использовать единый шаблон. | Добавить template-файл и ссылаться на него из индексной страницы. | `docs/work/devops-service-method-maps/service-page-template.md` | [DRR-0023](work/drr/drr-0023-devops-method-map-service-page-template.md) |
| `RS-08` | Использовать только стандартные Markdown-ссылки. | Запретить wiki-links и ссылки в code-block в правилах репозитория. | `[Title](relative/path.md)` во всех документах | [AGENTS.md](../AGENTS.md), [Contributing](contributing.md), `session: rollout-2026-02-03T23-59-36-019c254d-b8d8-7d53-a5cf-91385d840e14` |
| `RS-09` | Держать именование файлов в `lowercase-kebab-case`, пути стабильными. | Зафиксировать соглашение и применять `git mv` для переименований. | Конвенция используется для файлов в `docs/` | [AGENTS.md](../AGENTS.md), [Contributing](contributing.md) |
| `RS-10` | Ссылаться на `_sources` только если страница реально использует эти источники. | Ввести правило релевантной ссылки на первичный carrier и очищать лишние ссылки. | Применяется в `docs/**` | [AGENTS.md](../AGENTS.md), `session: rollout-2026-02-04T08-03-23-019c2708-a4e7-7f41-8266-fa73b9f0376b` |
| `RS-11` | В публикациях использовать человекочитаемые названия, machine-id выносить в internal. | Ввести human-first слой публикаций и отдельный internal schema-layer. | [Style guide](style-guide.md), `docs/work/_internal/**` | [DRR-0064](work/drr/drr-0064-publication-human-readable-naming-and-internal-machine-schema.md) |
| `RS-12` | Зафиксировать основной язык публикаций. | Выбрать primary language для `docs/**`; английский оставить для идентификаторов/терминов. | Основной язык публикаций: русский | [Style guide](style-guide.md), [DRR-0033](work/drr/drr-0033-publication-language-russian-primary.md) |
| `RS-13` | При переносе каталога устранять дубли и обновлять навигацию в том же change-set. | Сразу обновлять индексные страницы и TOC при перемещении файлов. | Контент `grade-system` перенесен на уровень `docs/work/`, ссылки обновлены | `session: rollout-2026-02-04T00-02-30-019c2550-5e8d-7910-b2ad-6edfadd8ad3b`, `commit: febec09`, `commit: 08281e3` |
| `RS-14` | Если факты в разных файлах конфликтуют, не делать автоматических правок. | Ввести блокирующее правило: остановка и запрос решения у владельца репозитория. | Правило действует как guardrail при изменениях структуры/контента | [AGENTS.md](../AGENTS.md), `session: rollout-2026-02-04T08-03-23-019c2708-a4e7-7f41-8266-fa73b9f0376b` |
| `RS-15` | Разделять `Repo-Design-Time` и `Repo-Run-Time` как два операционных контура. | Явно фиксировать, к какому контуру относится каждое новое правило/решение. | Этот документ + `docs/work/process-transduction/*.md` | [DRR-0068](work/drr/drr-0068-repo-oriented-split-design-time-vs-run-time-and-drr-materialization-policy.md), [DevOps direction — граф трансдукций (E.TGA)](work/process-transduction/devops-direction-transduction-graph.md) |
| `RS-16` | Для content-решений использовать materialization вместо прямых DRR-входов replay. | Применять цепочку `DRR -> T24 -> policy/spec carriers -> replay`. | `T24` в `docs/work/process-transduction/*` | [DRR-0067](work/drr/drr-0067-drr-design-time-provenance-and-t24-materialization.md), [DRR-0068](work/drr/drr-0068-repo-oriented-split-design-time-vs-run-time-and-drr-materialization-policy.md) |
| `RS-17` | Обрабатывать `superseded` через пере-материализацию текущего состояния. | В replay допускать только актуальные materialized rules; superseded DRR хранить как provenance. | `docs/work/drr/README.md` + materialized policy/spec carriers | [DRR-0068](work/drr/drr-0068-repo-oriented-split-design-time-vs-run-time-and-drr-materialization-policy.md) |

## Как переносить в другой проект

1. Скопировать этот файл и адаптировать пути в колонке "Реализация в этом репозитории".
2. Оставить `RS-01..RS-11` как базовый минимальный набор.
3. `RS-12` адаптировать под языковую политику целевого проекта.
4. `RS-13` и `RS-14` сохранить как операционные guardrails миграций.
5. Добавить `RS-15..RS-17`, если в проекте есть трансдукционный контур и DRR-реестр с возможными supersede.
