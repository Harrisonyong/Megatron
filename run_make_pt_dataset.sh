#!/bin/bash
set -ex
START_TIME=$SECONDS
CURRENT_DIR="$( cd "$( dirname "$0" )" && pwd )"
export PYTHONPATH=$PYTHONPATH:${CURRENT_DIR}
input_data_dir="/home/mai-llm-train-service/dataset/megatron_data/WuDaoCorpus2.0_base_sample/cleaned_zst"
output_dir="/home/mai-llm-train-service/dataset/megatron_data/WuDaoCorpus2.0_base_sample/idxbin"
load_dir="/home/mai-llm-train-service/qwen/megatron_qwen2_0.5B_T2"


run_cmd="python tools/preprocess_data.py 
--input ${input_data_dir} 
--output-prefix ${output_dir}/wodao_qwenbpe
--dataset-impl mmap
--patch-tokenizer-type QwenTokenizer
--load ${load_dir}
--workers 16
--append-eod
"
echo ${run_cmd}
eval ${run_cmd}