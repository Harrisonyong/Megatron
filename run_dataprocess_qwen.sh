#!/bin/bash
set -ex
CURRENT_DIR="$( cd "$( dirname "$0" )" && pwd )"
export PYTHONPATH=$PYTHONPATH:${CURRENT_DIR}

# 拥有多个json原始文件的目录
data_dir=/home/mai-llm-train-service/dataset/megatron_data/WuDaoCorpus2.0_base_sample

# 创建清洗后的包含多个json文件的目录
mkdir -p ${data_dir}/cleaned

# 逐个清洗每个json文件，json文件中text文本的key要设为content，-k输出的是过滤后的text的key，-p设置进程数
python3 tools/preprocess_wedoctor.py -i ${data_dir} -o ${data_dir}/cleaned -k text -p 32

# 合并所有清洗后数据
mkdir ${data_dir}/merged_cleaned
find ${data_dir}/cleaned -name "*.json" -exec cat {} + > ${data_dir}/merged_cleaned/merged_cleaned.json
rm -rf ${data_dir}/cleaned

# 此处设置分块数为10，如数据处理慢可设置稍大
NUM_PIECE=10

# 对merge的文件进行处理
# 查询数据长度，对数据进行拆分
NUM=$(sed -n '$=' ${data_dir}/merged_cleaned/merged_cleaned.json)
echo "total line of dataset is $NUM, data will be split into $NUM_PIECE pieces for processing"
NUM=`expr $NUM / $NUM_PIECE`
echo "each group is processing $NUM sample"
split_dir=${data_dir}/split
mkdir $split_dir
split -l $NUM --numeric-suffixes --additional-suffix=.jsonl ${data_dir}/merged_cleaned/merged_cleaned.json $split_dir/

# 将上面拆分的数据压缩保存
mkdir -p ${data_dir}/cleaned_zst/
o_path=${data_dir}/cleaned_zst
files=$(ls $split_dir/*.jsonl)
for filename in $files
do
   f=$(basename $filename)
   zstd -z $filename -o $o_path/$f.zst &
done

