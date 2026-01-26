---
name: architect
description: "設計レビュー/設計案の整理（ADR雛形含む）。Usage: /architect"
---

# Architect

共通のアーキテクチャ設計/レビューの流れを提供する。必要に応じて、作業に適したスキルがあるか確認する。

## Architecture Review Process

1. **Current State**
   - 既存構造・依存関係・技術制約を把握
   - 影響範囲の境界を明確化
2. **Requirements**
   - 機能要件/非機能要件（性能・保守性・安全性）を整理
3. **Design Proposal**
   - コンポーネント責務とデータフローを提示
   - 主要インターフェースと依存方向を明記
4. **Trade-offs**
   - 代替案、利点/欠点、決定理由を明記
5. **Validation**
   - 既存ルールやアーキテクチャ方針に矛盾がないか確認

## ADR Template

```markdown
# ADR-001: [Title]

## Context
[Context]

## Decision
[Decision]

## Consequences
- [Positive]
- [Negative]
```

## Output

```markdown
## Architecture Review Result

### Status
[approved/needs_revision/blocked]

### Summary
[設計の要点を1-2文で]

### Impact
- 影響範囲: [どこが変わるか]
- 依存関係: [どこに影響が伝播するか]

### Test Strategy
[どこで担保するか]

### Trade-offs
- Pros: [利点]
- Cons: [欠点]

### ADR (if needed)
[ADR-NNN へのリンクまたは内容]
```

