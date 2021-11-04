# the covid hand
- covid specific docker
- watchdog with worker mode

# build
- sudo docker build --no-cache --build-arg COVID_BRANCH=v1.2.9 -t coctohug-covid:latest .
- sudo docker build --build-arg COVID_BRANCH=v1.2.9 -t coctohug-covid:latest .

# docker-compose
- coctohug-covid: 
        image: coctohug-covid:latest 
        container_name: coctohug-covid
        hostname: pc1 
        restart: always 
        volumes: 
            - ~/.coctohug-covid:/root/.chia 
            - "/mnt/disk1:/plots1" 
            - "/mnt/disk2:/plots2" 
        environment: 
            - mode=fullnode 
            - worker_address=192.168.1.74 
            - plots_dir=/plots1:/plots2 
            - blockchains=covid 
        ports: 
            - 18120:18120 
            - 18129:18129

## Trademark Notice
CHIA NETWORK INC, CHIA™, the CHIA BLOCKCHAIN™, the CHIA PROTOCOL™, CHIALISP™ and the “leaf Logo” (including the leaf logo alone when it refers to or indicates Chia), are trademarks or registered trademarks of Chia Network, Inc., a Delaware corporation. *There is no affliation between this Coctohug project and the main Chia Network project.*