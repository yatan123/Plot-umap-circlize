# 一键安装 plot1cell 全部依赖（Windows + R 4.4.1）
# 包库固定 C:/Rlib44，避开中文用户名路径的编码问题
# 运行前必须设环境变量：TMPDIR/TMP/TEMP=C:/Rtmp44、HOME=C:/Rhome、R_LIBS_USER=C:/Rlib44
.libPaths("C:/Rlib44")
options(repos = c(CRAN = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(Ncpus = 8)
options(timeout = 3600)

# 1. CRAN 包，强制 Windows 二进制（R 4.4 二进制仓库已冻结，版本稍旧但够用）
install.packages(c("Rcpp", "remotes", "BiocManager", "Seurat", "circlize",
  "sp", "stringi", "xfun", "RcppArmadillo", "bitops", "zoo",
  "spam", "bit64", "RcppThread", "caTools", "hdf5r", "knitr", "rmarkdown",
  "tinytex", "plotly", "ggh4x", "MASS", "scales", "progress", "RColorBrewer",
  "reshape2", "ggbeeswarm", "purrr", "ComplexUpset", "matrixStats",
  "data.table", "Matrix", "cowplot", "rlang", "wordcloud"),
  type = "win.binary")
cat("== step1 CRAN done ==\n")

# 2. Bioconductor 包；清华/中科大已撤 Bioc 3.20，用官方源
library(BiocManager)
BiocManager::install(c("biomaRt", "GEOquery", "GenomeInfoDb",
  "simplifyEnrichment", "ComplexHeatmap", "EnsDb.Hsapiens.v86"),
  update = FALSE, ask = FALSE)
cat("== step2 Bioconductor done ==\n")

# 3. GitHub 包；纯 R 包加 build = FALSE 跳过 R CMD build（中文 HOME 下 build 会报编码错）
library(remotes)
install_github("chris-mcginnis-ucsf/DoubletFinder", upgrade = "never", build = FALSE)
install_github("mojaveazure/loomR", upgrade = "never", build = FALSE)
cat("== step3 GitHub done ==\n")

# 4. plot1cell 本体
install_github("TheHumphreysLab/plot1cell", upgrade = "never", build = FALSE)
cat("== step4 plot1cell done ==\n")

ip <- rownames(installed.packages())
cat("Seurat:", "Seurat" %in% ip, "\n")
cat("plot1cell:", "plot1cell" %in% ip, "\n")
cat("ComplexHeatmap:", "ComplexHeatmap" %in% ip, "\n")
cat("EnsDb.Hsapiens.v86:", "EnsDb.Hsapiens.v86" %in% ip, "\n")
cat("DoubletFinder:", "DoubletFinder" %in% ip, "\n")
cat("loomR:", "loomR" %in% ip, "\n")
