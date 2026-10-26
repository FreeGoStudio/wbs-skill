# WBS 任务拆分技能

把已确认需求整理成中文业务工作包和可独立交付的实施任务，支持维护已有任务归属、依赖、预算及产品任务。

- [技能入口](skills/wbs/SKILL.md)
- [任务生成模板](skills/wbs/references/task-template.md)
- [已有规划维护](skills/wbs/references/maintenance.md)

## 使用

安装后重新打开会话，可调用：

```text
使用 $wbs，将以下已确认需求拆成任务，沿用项目现有编号和目录。
```

也可请求调整已有工作包或检查任务依赖。技能不执行任务开发，不默认生成工时，不自动迁移旧清单。

## 脚本安装

已有本地项目时，在 PowerShell 中执行：

```powershell
powershell -ExecutionPolicy Bypass -File D:\workspace\wbs-skill\scripts\install-skill.ps1
```

或在克隆后的项目根目录运行 `./scripts/install-skill.ps1`。默认读取 `CODEX_HOME`，未设置时安装到 `%USERPROFILE%\.codex\skills\wbs`。可用 `-CodexHome "D:\Codex"` 指定安装到 `D:\Codex\skills\wbs`。

更新时再次运行同一命令。脚本先复制并校验文件，再替换安装目录；旧版本保存在 Codex 目录的 `skill-backups` 中，不会作为重复技能加载。安装暂存目录位于 `skill-install-staging`。

从 Git 安装需要 Git，使用 [install-from-git.ps1](scripts/install-from-git.ps1)：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-from-git.ps1 -RepoUrl "https://github.com/FreeGoStudio/wbs-skill.git" -Branch main
```

脚本每次克隆到临时目录的新子目录，调用本地安装器；不重置已有仓库。支持 `-CodexHome` 和 `-InstallRoot`，下载的副本保留在输出路径。

**远程一行安装需先将本项目文件推送到该仓库的 main 分支。** 当前本地交付不表示远程已发布；发布后可使用：

```powershell
iwr -UseB https://raw.githubusercontent.com/FreeGoStudio/wbs-skill/main/scripts/install-from-git.ps1 | iex
```

本地安装器：[install-skill.ps1](scripts/install-skill.ps1)。

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
