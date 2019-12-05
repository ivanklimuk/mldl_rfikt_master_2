install:
	python ./models/research/setup.py install

coco:
	python labelme2coco.py --labels ./labels.txt --input_dir ./data_raw/train/annotations --input_dir_images ./data_raw/train/images --output_dir ./data_coco/train
	python labelme2coco.py --labels ./labels.txt --input_dir ./data_raw/test/annotations --input_dir_images ./data_raw/test/images --output_dir ./data_coco/test
	python labelme2coco.py --labels ./labels.txt --input_dir ./data_raw/val/annotations --input_dir_images ./data_raw/val/images --output_dir ./data_coco/val

tf_records:
	cd ./models/research; \
	export PYTHONPATH=$$PYTHONPATH:`pwd`:`pwd`/slim; \
	python object_detection/dataset_tools/create_coco_tf_record.py --logtostderr \
    --train_image_dir=../../data_coco/train \
    --val_image_dir=../../data_coco/val \
    --test_image_dir=../../data_coco/test \
    --train_annotations_file=../../data_coco/train/annotations.json \
    --val_annotations_file=../../data_coco/val/annotations.json \
    --testdev_annotations_file=../../data_coco/test/annotations.json \
    --output_dir=../../data_tf_records