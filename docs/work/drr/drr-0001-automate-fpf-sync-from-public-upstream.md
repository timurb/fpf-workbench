# DRR-0001: Автоматизация синхронизации FPF из публичного upstream

## Статус

Принято

## Дата

2026-02-14

## Контекст

Репозиторий хранит `refs/fpf/FPF-Spec.md` как синхронизируемый source-of-truth артефакт. Upstream-репозиторий публичный, поэтому синхронизацию можно автоматизировать. Цель: уменьшить ручные операции, сохранив проверяемость изменений и прослеживаемость evidence-цепочки.

## Нормативный фрагмент FPF

> | Architectural Characteristic of Thought | What it protects / why it matters | The FPF Mechanisms that Preserve It |
> | :--- | :--- | :--- |
> | **Auditability & Traceability** | The unbreakable chain from a claim back to its evidence. This is the quality of being able to answer "Why is this true?" at any point. | **`Evidence Graph Referring (A.10)`**, the **`Design-Rationale Record (DRR) Method (E.9)`**, and the entire **`Trust & Assurance Calculus (B.3)`**. The architecture makes untraceable claims a modeling violation. |
> | **Evolvability** | The capacity of a model or system to adapt to new information or requirements without losing its conceptual integrity. | The **`Open-Ended Evolution Principle (P-10)`**, the **`Canonical Evolution Loop (B.4)`**, and the **`DRR Process (E.9)`**. Change is not a bug; it is a formally managed, first-class feature of the architecture. |

Источник: [refs/fpf/FPF-Spec.md](../../../refs/fpf/FPF-Spec.md)

## Решение

Использовать GitHub Actions workflow для планового и ручного запуска синхронизации FPF-спеки с автоматическим созданием pull request при изменениях.

## Реализация

- Добавить `.github/workflows/sync-fpf.yml`:
  - плановый триггер (`cron`) и ручной запуск (`workflow_dispatch`);
  - выполнение `tools/sync_fpf.sh`;
  - автоматическое создание pull request.
- Обновить `tools/sync_fpf.sh`:
  - upstream по умолчанию переведен на публичный HTTPS URL;
  - добавлены опциональные CLI-аргументы для URL и пути до спеки;
  - запись метаданных сделана детерминированной и shell-portable.
- Обновить `refs/fpf/README.md` (ручной и автоматический контуры обновления).

## Рассмотренные альтернативы

1. Оставить только ручную синхронизацию.
2. Выполнять авто-коммит напрямую в default-ветку.
3. Автоматизировать синхронизацию через PR-поток (выбрано).

## Обоснование

Вариант 3 сохраняет reviewability и снижает риск нежелательных апдейтов, потому что изменения проходят через pull request. Также вариант соответствует требованию evidence-цепочки: каждое обновление фиксируется как отдельный проверяемый change-артефакт.

## Последствия

- Позитивно: воспроизводимая синхронизация, меньше ручной нагрузки, прозрачный trail в истории PR.
- Позитивно: нет зависимости от приватных credentials upstream-репозитория.
- Риск: зависимость от доступности GitHub Actions и стороннего action.
- Смягчение: workflow минимален и может быть запущен вручную (`workflow_dispatch`) при сбое расписания.

## Evidence-ссылки

- `.github/workflows/sync-fpf.yml`
- `tools/sync_fpf.sh`
- `refs/fpf/README.md`
- `docs/work/drr/README.md`
