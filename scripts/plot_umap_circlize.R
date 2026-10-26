# plot1cell UMAP 环形图绘图模板
# 用法：复制到输出目录，只改 4 处【改这里】标记，然后用 Rscript 运行
# 运行前必须设环境变量（Windows 中文用户名必设）：
#   TMPDIR=C:/Rtmp44 TMP=C:/Rtmp44 TEMP=C:/Rtmp44 HOME=C:/Rhome R_LIBS_USER=C:/Rlib44
.libPaths("C:/Rlib44")
library(Seurat)
library(plot1cell)

# 【改这里 1】Seurat 对象 .rds 绝对路径
obj <- readRDS("E:/xxx/obj.rds")
dim(obj)
names(obj@reductions)

# 注释列全部转因子；列名按自己数据改
# 【改这里 2】中心 UMAP 着色列（细胞类型）
# 【改这里 3】外圈轨道 1（分组）
# 【改这里 4】外圈轨道 2（样本）；只要一条轨道就删掉对应行和 add_track
obj$celltype <- factor(obj$celltype)
obj$group <- factor(obj$group)
obj$orig.ident <- factor(obj$orig.ident)
Idents(obj) <- "celltype"

# 准备环形图数据
circ_data <- prepare_circlize_data(obj, scale = 0.8)

# 随机颜色；固定种子保证颜色可复现
set.seed(1234)
cluster_colors <- rand_color(length(levels(obj)))
group_colors <- rand_color(length(names(table(obj$group))))
rep_colors <- rand_color(length(names(table(obj$orig.ident))))

# 输出 6 英寸正方形、300 dpi 的 PNG；尺寸可在细胞类型/样本多时调大到 8
png(filename = "circlize_plot.png", width = 6, height = 6, units = "in", res = 300)
plot_circlize(circ_data, do.label = TRUE, pt.size = 0.4,
  col.use = cluster_colors, bg.color = "white", kde2d.n = 200,
  repel = TRUE, label.cex = 0.6)
# 添加分组和样本轨道
add_track(circ_data, group = "group", colors = group_colors, track_num = 2)
add_track(circ_data, group = "orig.ident", colors = rep_colors, track_num = 3)
dev.off()
