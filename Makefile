install:
	python ./models/research/setup.py install

coco:
	python labelme2coco.py --labels ./data/labels.txt --input_dir ./data/data_raw/train/annotations --input_dir_images ./data/data_raw/train/images --output_dir ./data/data_coco/train
	python labelme2coco.py --labels ./data/labels.txt --input_dir ./data/data_raw/test/annotations --input_dir_images ./data/data_raw/test/images --output_dir ./data/data_coco/test
	python labelme2coco.py --labels ./data/labels.txt --input_dir ./data/data_raw/val/annotations --input_dir_images ./data/data_raw/val/images --output_dir ./data/data_coco/val

csv:
	python labelme2csv.py --labels ./data/labels.txt --input_dir ./data/data_raw/train/annotations --input_dir_images ./data/data_raw/train/images --output_dir ./data/data_csv/train
	python labelme2csv.py --labels ./data/labels.txt --input_dir ./data/data_raw/test/annotations --input_dir_images ./data/data_raw/test/images --output_dir ./data/data_csv/test
	python labelme2csv.py --labels ./data/labels.txt --input_dir ./data/data_raw/val/annotations --input_dir_images ./data/data_raw/val/images --output_dir ./data/data_csv/val

tf_records_coco:
	cd ./models/research; \
	export PYTHONPATH=$$PYTHONPATH:`pwd`:`pwd`/slim; \
	python object_detection/dataset_tools/create_coco_tf_record.py --logtostderr \
    --train_image_dir=../../data/data_coco/train \
    --val_image_dir=../../data/data_coco/val \
    --test_image_dir=../../data/data_coco/test \
    --train_annotations_file=../../data/data_coco/train/annotations.json \
    --val_annotations_file=../../data/data_coco/val/annotations.json \
    --testdev_annotations_file=../../data/data_coco/test/annotations.json \
    --output_dir=../../data/data_tf_records_coco

tf_records_csv:
	cd ./models/research; \
	export PYTHONPATH=$$PYTHONPATH:`pwd`:`pwd`/slim; \
	python object_detection/dataset_tools/create_csv_tf_record.py \
	--csv_input=../../data/data_csv/train/annotations.csv \
	--image_dir=../../data/data_csv/train/images \
	--output_path=../../data/data_tf_records_csv/csv_train.record; \
	python object_detection/dataset_tools/create_csv_tf_record.py \
	--csv_input=../../data/data_csv/val/annotations.csv \
	--image_dir=../../data/data_csv/val/images \
	--output_path=../../data/data_tf_records_csv/csv_val.record

train_json:
	cd ./models/research; \
	export PYTHONPATH=$$PYTHONPATH:`pwd`:`pwd`/slim; \
	python object_detection/model_main.py \
    --pipeline_config_path=../../choco/model/train_json.config \
    --model_dir=../../choco \
    --num_train_steps=50000 \
    --alsologtostderr

train_csv:
	cd ./models/research; \
	export PYTHONPATH=$$PYTHONPATH:`pwd`:`pwd`/slim; \
	python object_detection/model_main.py \
    --pipeline_config_path=../../choco/model/train_csv.config \
    --model_dir=../../choco \
    --num_train_steps=50000 \
    --alsologtostderr

train:
	$(MAKE) train_json