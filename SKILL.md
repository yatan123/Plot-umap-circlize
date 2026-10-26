---
name: Plot-umap-circlize
description: 用 plot1cell 对 Seurat 单细胞对象绘制"圈中圈"UMAP 环形图（中心 UMAP 按细胞类型着色 + 外圈分组/样本注释轨道）。当用户要求画 UMAP 环形图、circos 圈图、plot1cell 圈中圈图，或提供 .rds 单细胞数据要求这种可视化时使用。
agent_created: true
---

# Plot-umap-circlize — plot1cell UMAP 环形图

## Overview

对任意含 UMAP 降维和细胞类型注释的 Seurat 对象（.rds），生成 plot1cell 风格环形图：
中心 UMAP（细胞类型着色 + 轮廓圈 + 标签），外圈最多两条注释轨道（分组、样本）。
GitHub 包：https://github.com/TheHumphreysLab/plot1cell

## 前置环境（Windows，R 4.4.1）

1. 检查关键包是否已装（`installed.packages()` 查 `plot1cell`、`Seurat`）。
2. 缺包则运行 `scripts/install_plot1cell.R`：
   - 包库固定 `C:/Rlib44`，避开中文用户名编码坑
   - CRAN 用清华镜像 + `type="win.binary"` 强制二进制
   - Bioconductor 3.20 清华/中科大已撤，用官方源
   - GitHub 包（plot1cell、DoubletFinder、loomR）加 `build = FALSE`
3. **每次运行 Rscript 必须设环境变量**，否则中文用户名下临时目录/HOME 编码报错：

```
TMPDIR=C:/Rtmp44 TMP=C:/Rtmp44 TEMP=C:/Rtmp44 HOME=C:/Rhome R_LIBS_USER=C:/Rlib44
```

bash 写法：`TMPDIR="C:/Rtmp44" TMP="C:/Rtmp44" TEMP="C:/Rtmp44" R_LIBS_USER="C:/Rlib44" HOME="C:/Rhome" "/c/Program Files/R/R-4.4.1/bin/Rscript.exe" 脚本.R`

## 工作流

1. **确认数据**：拿到 Seurat .rds 绝对路径。对象必须含 `umap` reduction 和细胞类型注释；缺 UMAP 先 RunUMAP。
2. **查元数据**：先跑小脚本查看 `colnames(obj@meta.data)`、注释列的 levels、`names(obj@reductions)`，再与用户确认三列：
   - 中心着色列：细胞类型（常见 `celltype`）
   - 外圈轨道 1：分组（常见 `group`/`condition`/`Group`）
   - 外圈轨道 2：样本（常见 `orig.ident`/`sample_id`）
   - 用户只要一条轨道时，删掉一条 `add_track`
3. **改模板**：复制 `scripts/plot_umap_circlize.R` 到输出目录，只改【改这里】标记的参数（rds 路径、三个列名），不重写代码。颜色固定 `set.seed(1234)` 保证可复现。
4. **运行**：cd 到输出目录（PNG 用相对路径输出，避免中文绝对路径写 png 失败），后台运行脚本，成功标志是 log 末尾出现 `null device 1`。
5. **交付**：present_files 交付 PNG + 脚本；确认成图质量（标签可读、轨道齐全）。

## 常用微调（改参数重跑，约 1-2 分钟）

- 标签太小：`label.cex` 0.6 → 0.8
- 点太大/太小：`pt.size` 0.4
- 细胞类型或样本多、外圈太挤：`png` 的 `width`/`height` 6 → 8（英寸）
- 轮廓线太碎/太糊：`kde2d.n` 200
- 轨道顺序：`track_num` 2/3

## 注意

- 绘图前把所有注释列转 `factor`，`Idents(obj) <- 细胞类型列`（`prepare_circlize_data` 和 `plot_circlize` 按 Idents 取 cluster）。
- 大对象（>10 万细胞）读入慢、内存需 >16GB；内存吃紧把 `kde2d.n` 降到 100。
- 只画图不需要动 assay / 重新归一化。
- `add_track` 的 `group` 参数是元数据列名（字符串），不是因子对象。

## Resources

- `scripts/plot_umap_circlize.R` — 绘图模板，含【改这里】标记
- `scripts/install_plot1cell.R` — 一键装齐 plot1cell 全部依赖
