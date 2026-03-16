# latex-pdf-writer

一个用于 LaTeX 论文写作与 PDF 产出的轻量工具仓库，包含：

- 会议模板初始化（ICML 2026、NeurIPS 2025）
- 基于 `tectonic` 的可复现编译脚本
- PDF 单页渲染为图片（用于版面检查）
- PDF 单页文本提取（用于纯文本分析）
- 常见 LaTeX 报错排查参考

## 目录结构

```text
.
├── README.md
├── SKILL.md
├── references/
│   └── troubleshooting.md
└── scripts/
	├── compile_pdf.sh
	├── init_icml26.sh
	├── init_nips25.sh
	├── pdf_page_image.py
	└── pdf_page_text.py
```

## 环境要求

- Linux/macOS（bash 环境）
- `curl`
- `unzip`（或 `busybox unzip`）
- `tectonic`（用于编译 LaTeX）
- Python 3（用于 PDF 工具）

Python 依赖（按需安装）：

```bash
python3 -m pip install --user pypdf pypdfium2
```

## 快速开始

1) 检查 LaTeX 编译器是否可用

```bash
scripts/compile_pdf.sh --check
```

2) 初始化模板（二选一）

ICML 2026：

```bash
scripts/init_icml26.sh ./work/icml26
```

NeurIPS 2025：

```bash
scripts/init_nips25.sh ./work/nips25
```

3) 编辑 `.tex` 内容后编译

```bash
scripts/compile_pdf.sh ./work/icml26/example_paper.tex
```

编译成功后会输出 PDF 路径，例如：`.../example_paper.pdf`。

## 脚本说明

### `scripts/compile_pdf.sh`

用途：编译一个 `.tex` 文件。

- 优先使用仓库上级路径中的 `.local/bin/tectonic`
- 若该路径不存在，则回退到系统 `PATH` 中的 `tectonic`

用法：

```bash
scripts/compile_pdf.sh --check
scripts/compile_pdf.sh /path/to/paper.tex
```

### `scripts/init_icml26.sh`

用途：下载并解压 ICML 2026 官方模板。

用法：

```bash
scripts/init_icml26.sh /path/to/target-dir
```

模板来源：`https://media.icml.cc/Conferences/ICML2026/Styles/icml2026.zip`

### `scripts/init_nips25.sh`

用途：下载并解压 NeurIPS 2025 模板，并自动生成单栏入口文件。

会生成：

- `neurips_2025.sty`
- `neurips_2025.tex`
- `nips25_single_column.tex`（已启用 `preprint` 选项）

用法：

```bash
scripts/init_nips25.sh /path/to/target-dir
```

模板来源：`https://media.neurips.cc/Conferences/NeurIPS2025/Styles.zip`

### `scripts/pdf_page_image.py`

用途：将 PDF 的第 `k` 页（1-based）渲染成 PNG 图片。

用法：

```bash
python3 scripts/pdf_page_image.py <pdf-file> <k> [output-png] [--scale 2.0]
```

示例：

```bash
python3 scripts/pdf_page_image.py ./paper.pdf 3
python3 scripts/pdf_page_image.py ./paper.pdf 3 ./page3.png --scale 2.5
```

### `scripts/pdf_page_text.py`

用途：提取 PDF 第 `k` 页（1-based）文本。

用法：

```bash
python3 scripts/pdf_page_text.py <pdf-file> <k>
```

示例：

```bash
python3 scripts/pdf_page_text.py ./paper.pdf 2
```

## 常见问题

可查看：`references/troubleshooting.md`

高频问题：

- `xxx.sty not found`：确保样式文件在同目录或使用可获取依赖的编译环境
- 引用显示 `?`：检查 `.bib` 与引用键，重新完整编译
- `Undefined control sequence`：检查命令拼写及所需包是否导入

## 推荐工作流

```bash
# 1) 初始化模板
scripts/init_icml26.sh ./paper

# 2) 编辑 tex
#    (例如 ./paper/example_paper.tex)

# 3) 编译
scripts/compile_pdf.sh ./paper/example_paper.tex

# 4) 检查第 1 页版面
python3 scripts/pdf_page_image.py ./paper/example_paper.pdf 1

# 5) 提取第 1 页文本
python3 scripts/pdf_page_text.py ./paper/example_paper.pdf 1
```

## License

本仓库脚本代码默认按仓库所有者声明处理。会议模板文件版权归各会议官方组织方所有，请遵循对应模板许可条款。
