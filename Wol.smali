## Inject this in the thread where the remote would normally send a WoL
## Make sure that .locals is >=7 in the function you inject it into
## (set it to 7 if not)

## By default, sends a UDP packet with the letter a to port 9876

    .line 17
    :try_start_0
## CHANGE THIS TO THE IP
    const-string v4, "192.168.1.10"

    invoke-static {v4}, Ljava/net/InetAddress;->getByName(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object v2

    .line 19
    .local v2, "serverAddress":Ljava/net/InetAddress;
    new-instance v3, Ljava/net/DatagramSocket;

    invoke-direct {v3}, Ljava/net/DatagramSocket;-><init>()V

    .line 20
    .local v3, "socket":Ljava/net/DatagramSocket;
    .line 21
    :cond_0
    new-instance v1, Ljava/net/DatagramPacket;

    const-string v4, "a"

    invoke-virtual {v4}, Ljava/lang/String;->getBytes()[B

    move-result-object v4

    const/4 v5, 0x1

# Port 9876
    const/16 v6, 0x2694

    invoke-direct {v1, v4, v5, v2, v6}, Ljava/net/DatagramPacket;-><init>([BILjava/net/InetAddress;I)V

    .line 23
    .local v1, "packet":Ljava/net/DatagramPacket;
    invoke-virtual {v3, v1}, Ljava/net/DatagramSocket;->send(Ljava/net/DatagramPacket;)V

    .line 24
    invoke-virtual {v3}, Ljava/net/DatagramSocket;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 28
    .end local v1    # "packet":Ljava/net/DatagramPacket;
    .end local v2    # "serverAddress":Ljava/net/InetAddress;
    .end local v3    # "socket":Ljava/net/DatagramSocket;
    :goto_0
    return-void

    .line 25
    :catch_0
    move-exception v0

    .line 26
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
