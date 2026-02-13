# fpf-workbench

Текстовый репозиторий для документации и рабочих артефактов, использующих FPF как методологическую опору.

## Навигация

- Стартовая страница документации: [docs/index.md](docs/index.md)
- Правила внесения изменений: [docs/contributing.md](docs/contributing.md)
- Конвенции оформления: [docs/style-guide.md](docs/style-guide.md)
- FPF-спека (source of truth, синхронизируется из upstream): [refs/fpf/FPF-Spec.md](refs/fpf/FPF-Spec.md)
- Общий TOC: [docs/_generated/toc.md](docs/_generated/toc.md)

## Структура репозитория

- `docs/` — основная документация и рабочие страницы.
- `refs/fpf/` — внешние референсы по FPF.
- `tools/` — служебные скрипты и проверки.

## Базовые правила

- Используйте стандартные Markdown-ссылки: `[Title](relative/path.md)`.
- Не используйте wiki-links вида `[[...]]`.
- Сохраняйте стабильные пути и имена файлов в формате `lowercase-kebab-case`.
- Не редактируйте вручную `refs/fpf/FPF-Spec.md`.

## Быстрый старт

1. Откройте [docs/index.md](docs/index.md) как точку входа.
2. Перед изменениями прочитайте [docs/contributing.md](docs/contributing.md) и [docs/style-guide.md](docs/style-guide.md).
3. При добавлении новой страницы обеспечьте навигацию на нее через индекс или TOC.
