# Plot-umap-circlize

基于 [plot1cell](https://github.com/TheHumphreysLab/plot1cell) 的 UMAP「圈中圈」绘图技能，适用于已有 UMAP 降维和细胞类型注释的 Seurat 对象。

- 中心：按细胞类型着色的 UMAP、轮廓和标签。
- 外圈：分组、样本两条注释轨道，可按需保留一条。
- 输出：`circlize_plot.png`，默认 6 × 6 英寸、300 dpi。

## 文件

| 文件 | 用途 |
| --- | --- |
| [SKILL.md](SKILL.md) | 技能说明与操作流程 |
| [scripts/plot_umap_circlize.R](scripts/plot_umap_circlize.R) | 绘图模板 |
| [scripts/install_plot1cell.R](scripts/install_plot1cell.R) | 依赖安装脚本 |
| [参考文献 PDF](references/Molecular%20architecture%20of%20the%20developing%20mouse%20brain.pdf) | Molecular architecture of the developing mouse brain |

## 数据与环境

模板面向 **Windows + R 4.4.1**，包库固定为 `C:/Rlib44`。输入为 Seurat `.rds` 文件，需包含 `umap` reduction，以及以下元数据列：

| 默认列名 | 含义 |
| --- | --- |
| `celltype` | 中心 UMAP 的细胞类型 |
| `group` | 外圈分组 |
| `orig.ident` | 外圈样本 |

列名可按实际数据调整。缺少 UMAP 时，先完成 UMAP 降维。

## 快速使用

### 1. 下载与安装依赖

克隆仓库，或在 GitHub 页面选择 **Code → Download ZIP** 后解压。

在仓库根目录打开 PowerShell，设置运行环境：

```powershell
New-Item -ItemType Directory -Force -Path C:/Rtmp44,C:/Rhome,C:/Rlib44 | Out-Null
$env:TMPDIR = 'C:/Rtmp44'
$env:TMP = 'C:/Rtmp44'
$env:TEMP = 'C:/Rtmp44'
$env:HOME = 'C:/Rhome'
$env:R_LIBS_USER = 'C:/Rlib44'
```

未安装依赖时运行：

```powershell
& 'C:/Program Files/R/R-4.4.1/bin/Rscript.exe' scripts/install_plot1cell.R
```

R 安装位置不同，请修改命令中的路径。每次新开 PowerShell 运行脚本前，都需重新设置上述环境变量。

### 2. 修改绘图模板

将 `scripts/plot_umap_circlize.R` 复制到输出目录，仅调整数据路径、注释列名和必要的绘图参数。

- 将 `E:/xxx/obj.rds` 替换为实际 `.rds` 绝对路径。
- 列名变化时，同步修改因子转换、`Idents`、颜色统计及 `add_track` 中对应的列名。
- 只需一条外圈时，删除另一条轨道对应的因子转换、颜色定义及 `add_track`。

### 3. 运行与查看结果

在设置过环境变量的 PowerShell 中进入输出目录，再运行复制后的脚本：

```powershell
Set-Location 'E:/your-output'
& 'C:/Program Files/R/R-4.4.1/bin/Rscript.exe' plot_umap_circlize.R
```

图片保存在当前目录。运行结束后检查 `circlize_plot.png`，确认标签清楚、外圈注释齐全。模板使用相对路径输出 PNG，便于避开中文绝对路径的编码问题。

## 参数调整

| 参数 | 默认值 | 用途 |
| --- | --- | --- |
| `label.cex` | `0.6` | 标签大小，可调至 `0.8` |
| `pt.size` | `0.4` | 点大小 |
| `width` / `height` | `6` | 图片尺寸，注释密集时可调至 `8` |
| `kde2d.n` | `200` | 轮廓计算网格，内存紧张时可降至 `100` |
| `track_num` | `2` / `3` | 外圈轨道位置 |

颜色通过 `set.seed(1234)` 固定随机种子。绘图前注释列需转为 `factor`；`add_track` 的 `group` 参数填写元数据列名字符串。该模板使用现有降维与注释，不需要重新归一化。

## 作为 Codex 技能使用

将完整仓库目录放入本机技能目录，例如 `~/.agents/skills/Plot-umap-circlize/`，保留 `SKILL.md`、`scripts/` 和 `references/` 的相对位置。

示例请求：

> 使用 Plot-umap-circlize，将 E:/data/obj.rds 绘制为 UMAP 圈中圈图。细胞类型列为 celltype，分组列为 group，样本列为 orig.ident。

## 参考资料

- 绘图工具：[TheHumphreysLab/plot1cell](https://github.com/TheHumphreysLab/plot1cell)。
- 随附文献：*Molecular architecture of the developing mouse brain*，见 `references/`。文献用于阅读参考，绘图输入仍需自行提供 Seurat 对象。
