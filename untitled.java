    private void initCall() {
    //按钮
        Toast.makeText(this, "Init Call", Toast.LENGTH_SHORT).show();

        //agent开始监听（事件驱动
        agent.addOnCallsUpdatedListener(callsUpdatedListener -> {
        //得到所有的call
            List<Call> addedCalls = callsUpdatedListener.getAddedCalls();
            for (Call call : addedCalls) {
                //2如果是打进来的call 则这样处理：
                if (call.getIsIncoming()) {
                    //2.2 显示按钮
                    runOnUiThread(() -> Toast.makeText(this, "Incoming call!", Toast.LENGTH_SHORT).show());

                    //2.3 加listener?
                    call.addOnCallStateChangedListener(p -> setStatus(call.getState().toString()));

                    //2.4加远程
                    call.addOnRemoteParticipantsUpdatedListener(participantsUpdatedListener -> {
                        //241 找到那边的参与者
                        List<RemoteParticipant> addedParticipants = participantsUpdatedListener.getAddedParticipants();
                        for (RemoteParticipant participant: addedParticipants) {
                            //242 对每一个参与者得到他的stream
                            participant.addOnVideoStreamsUpdatedListener(remoteVideoStreamListener -> {
                                List<RemoteVideoStream> addedStreams = remoteVideoStreamListener.getAddedRemoteVideoStreams();

                                //243 如果有 则render出来且加到我的view
                                for (RemoteVideoStream stream : addedStreams) {
                                    if (stream.getIsAvailable()) {
//                                      // Renders C1 stream
                                        runOnUiThread(() -> {
                                            Toast.makeText(this, "Stream available!", Toast.LENGTH_SHORT).show();
                                            Renderer renderer = new Renderer(stream, this);
                                            RendererView view = renderer.createView(new RenderingOptions(ScalingMode.Fit));
                                            remoteVideoView.addView(view);
                                        });
                                    }
                                }
                            });
                        }
                    });

                    //2.5 
                    AcceptCallOptions options = new AcceptCallOptions();
                    VideoOptions videoOptions = null;

                    DeviceManager deviceManager = null;
                    try {
                        deviceManager = client.getDeviceManager().get();
                    } catch (ExecutionException e) {
                        e.printStackTrace();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }

                    //251 设置自拍 设置videoOptions 设置AcceptCallOptions
                    VideoDeviceInfo camera = deviceManager.getCameraList().get(0);
                    LocalVideoStream localVideoStream = new LocalVideoStream(camera, this);
                    videoOptions = new VideoOptions(localVideoStream);

                    options.setVideoOptions(videoOptions);

                    //252 接通电话
                    call.accept(this, options);
                    this.call = call;

                    //253 显示自拍
                    runOnUiThread(() -> {
                        Renderer renderer = new Renderer(localVideoStream, this);
                        RendererView view = renderer.createView(new RenderingOptions(ScalingMode.Fit));
                        localVideoView.addView(view);
                    });

                }
            }
        });
    }