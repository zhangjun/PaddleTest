# 输入变量：yaml、设置卡数CPU/SET_CUDA/SET_MULTI_CUDA

cd ${Project_path} #确定下执行路径
ls
ls ${Project_path}/../  #通过相对路径找到 scripts 的路径，需要想一个更好的方法替代
ls ${Project_path}/../scripts
cp ${Project_path}/../scripts/shell/prepare.sh .
source prepare.sh
bash prepare.sh ${1} ${2}

if [[ -d ${output_dir}/${model_name} ]];then
    params_dir=$(ls ${output_dir}/${model_name})
    echo "######  params_dir"
    echo $params_dir
    if [[ -f ${output_dir}/$params_dir/latest.pdparams ]];then
        pretrained_model=${output_dir}/$params_dir/latest
    else
        pretrained_model="null"
    fi
else
    pretrained_model="null"
fi

case ${model_type} in
ImageNet|slim|metric_learning)
    python tools/infer.py -c $line \
        -o Global.pretrained_model=${pretrained_model} \
        > ${log_path}/infer/${model_name}.log 2>&1
;;
Cartoonface)
    echo "infer_exit_code: unspported" >> ${log_path}/infer/${model_name}.log
;;
DeepHash|GeneralRecognition)
    echo "infer_exit_code: unspported" >> ${log_path}/infer/${model_name}.log
;;
Logo)
    echo "infer_exit_code: unspported" >> ${log_path}/infer/${model_name}.log
;;
Products)
    echo "infer_exit_code: unspported" >> ${log_path}/infer/${model_name}.log
;;
PULC)
    echo "infer_exit_code: unspported" >> ${log_path}/infer/${model_name}.log
;;
reid)
    echo "infer_exit_code: unspported" >> ${log_path}/infer/${model_name}.log
;;
Vehicle)
    echo "infer_exit_code: unspported" >> ${log_path}/infer/${model_name}.log
;;
esac

if [[ $? -eq 0 ]] && [[ $(grep -c  "Error" ${log_path}/infer/${model_name}.log) -eq 0 ]];then
    echo -e "\033[33m infer of ${model_name}  successfully!\033[0m"| tee -a ${log_path}/result.log
    echo "infer_exit_code: 0.0" >> ${log_path}/infer/${model_name}.log
else
    cat ${log_path}/infer/${model_name}.log
    echo -e "\033[31m infer of ${model_name} failed!\033[0m"| tee -a ${log_path}/result.log
    echo "infer_exit_code: 1.0" >> ${log_path}/infer/${model_name}.log
fi
