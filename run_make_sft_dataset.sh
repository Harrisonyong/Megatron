set -ex
START_TIME=$SECONDS
CURRENT_DIR="$( cd "$( dirname "$0" )" && pwd )"
export PYTHONPATH=$PYTHONPATH:${CURRENT_DIR}

input_data_path=/home/mai-llm-train-service/dataset/megatron_sft_data/qwen_sft.json
seq_len=1000
output_data_dir=/home/mai-llm-train-service/dataset/megatron_sft_data
load_dir=/home/mai-llm-train-service/qwen/megatron_qwen2_0.5B_T2_P2

python tools/preprocess_data_sft_idxmap.py\
  --input ${input_data_path} \
  --output-prefix ${output_data_dir}/mmap_qwen2_sft \
  --patch-tokenizer-type Qwen2Tokenizer \
  --load ${load_dir} \
  --seq-length ${seq_len} \
  --workers 8 \
  --partitions 1 \

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "$(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"