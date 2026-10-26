# WBS 任务拆分技能

把已确认需求整理成中文业务工作包和可独立交付的实施任务，支持维护已有任务归属、依赖、预算及产品任务。

- [技能入口](skills/wbs/SKILL.md)
- [任务生成模板](skills/wbs/references/task-template.md)
- [已有规划维护](skills/wbs/references/maintenance.md)

## 使用

将 `skills/wbs` 文件夹复制到 Codex 的用户技能目录（通常为 `~/.codex/skills/wbs`）。已存在同名技能时先检查差异，避免覆盖本地修改。重新打开会话后可调用：

```text
使用 $wbs，将以下已确认需求拆成任务，沿用项目现有编号和目录。
```

也可请求调整已有工作包或检查任务依赖。技能不执行任务开发，不默认生成工时，不自动迁移旧清单。

## 维护与验证

本项目是技能源码仓库。修改源码并验证后，同步到安装目录；安装副本不作为另一份独立源码维护。技能正文及引用资源可整体复制使用，不依赖原业务项目。

使用已安装的 skill-creator 验证器检查技能：

```powershell
python -X utf8 "$env:USERPROFILE/.codex/skills/.system/skill-creator/scripts/quick_validate.py" ./skills/wbs
git diff --check
git diff --cached --check
```

另需核对模板引用与规则一致性；格式验证不等同于真实需求拆分验收。

## 来源

提炼自 `D:/workspace/hl-k_task` 的 `AGENTS.md` 与 `docs/03-任务清单/任务生成模板.md`，来源提交为 `85404f633eb02e03e6a2ac6eb11f6b6866df0fca`。移除了对原项目目录、编号索引路径及业务案例的依赖；原项目文档保持原状。
