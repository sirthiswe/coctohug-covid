# the covid hand
- covid specific docker
- log parser

# build
- sudo docker build --no-cache --build-arg CODE_BRANCH=v1.2.9 -t coctohug-covid:latest .
- sudo docker build --build-arg CODE_BRANCH=v1.2.9 -t coctohug-covid:latest .

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
            - controller_address=192.168.1.74 
            - worker_address=192.168.1.74
            - plots_dir=/plots1:/plots2 
        ports: 
            - 12641:12641 
            - 18120:18120 
            - 18129:18129

## Trademark Notice
CHIA NETWORK INC, CHIA™, the CHIA BLOCKCHAIN™, the CHIA PROTOCOL™, CHIALISP™ and the “leaf Logo” (including the leaf logo alone when it refers to or indicates Chia), are trademarks or registered trademarks of Chia Network, Inc., a Delaware corporation. *There is no affliation between this Coctohug project and the main Chia Network project.*Sun Nov 28 21:00:50 CST 2021
Tue Nov 30 09:39:11 CST 2021
Wed Dec 1 10:17:43 CST 2021
