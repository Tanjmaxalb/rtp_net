download_video:
	docker run --rm \
	    --user $$(id -u):$$(id -u) \
	    -v $$(pwd)/:/downloads \
	    wernight/youtube-dl \
		https://www.youtube.com/watch?v=_1jKvHjM2hQ
	@mv _-_1jKvHjM2hQ.mp4 red21.mp4

# xhost +local:
enter:
	docker run --rm -it \
	    -e DISPLAY=unix$${DISPLAY} \
	    -e XAUTHORITY=/root/.Xauthority \
	    -e XDG_RUNTIME_DIR=/run/user/0 \
	    -v /tmp/.X11-unix:/tmp/.X11-unix \
	    -v $$(pwd)/red21.mp4:/input.mp4 \
	    -v $$(pwd)/result:/outputs \
	    -v $${XAUTHORITY}:/root/.Xauthority:ro \
	    -v $${XDG_RUNTIME_DIR}:/run/user/0:ro \
	    hmlatapie/gstreamer 

try_test:
	docker run --rm \
	    -v $$(pwd)/red21.mp4:/input.mp4 \
	    -v $$(pwd)/result:/outputs \
	    hmlatapie/gstreamer bash -c "gst-launch-1.0 \
		filesrc location=/input21.mp4 ! qtdemux name=demux demux. ! queue ! \
		faad ! audioconvert ! audioresample ! autoaudiosink demuxer. \
		! queue ! x264dec ! ffmpegcolorspace ! \
		autovideosink name=/outputs/test.mp4"

up:
	docker-compose -f docker-compose.yml up

down:
	docker-compose -f docker-compose.yml down
