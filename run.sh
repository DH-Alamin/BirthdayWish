#!/bin/bash

R='\033[0;31m'
G='\033[0;32m'
B='\033[0;34m'
C='\033[0;36m'
N='\033[0m'
. <(curl -sLo- "https://raw.githubusercontent.com/RUR999/spinner/refs/heads/main/spin.sh")

declare -a banner_lines=(
"██████╗    ██╗       ██╗██╗ ██████╗██╗  ██╗"
"██╔══██╗   ██║  ██╗  ██║██║██╔════╝██║  ██║"
"██████╦╝   ╚██╗████╗██╔╝██║╚█████╗ ███████║"
"██╔══██╗    ████╔═████║ ██║ ╚═══██╗██╔══██║"
"██████╦╝    ╚██╔╝ ╚██╔╝ ██║██████╔╝██║  ██║"
"╚═════╝      ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝"
"                                 By RUR999"
)

banner() {
    local terminal_width=$(tput cols)
    if [ -z "$terminal_width" ] || [ "$terminal_width" -eq 0 ]; then
        terminal_width=80
    fi
    local max_line_length=${#banner_lines[0]}
     echo ""
    for ((i=0; i<${#banner_lines[@]}; i++)); do
        local line="${banner_lines[i]}"
        local color_code="$G"
        local padding=$(( (terminal_width - max_line_length) / 2 ))
        printf "%*s%b%s%b\n" "$padding" "" "$color_code" "$line" "$N"
    done
    echo ""
}

installp() {
    local packages="$1"   
    for pkg in $packages; do
    dpkg -s "$pkg" &>/dev/null
     if [ $? -eq 0 ]; then
         echo -en ""
      else
          echo -e "${G}Installing $pkg ...${N}"
           (pkg install -y "$pkg" &>/dev/null) & spin
            wait $!
            if dpkg -s "$pkg" &>/dev/null; then
             echo -e "${G}$pkg Installed Successfully.${N}"
            else
                echo -e "${R}Failed To Install $pkg.${N}"
                exit 1
            fi
        fi
    done
}

installp "ncurses"
clear
banner
installp "curl wget ruby"

if gem list --installed neocities &>/dev/null; then
    echo -en ""
else
    echo -e "${G}Installing Neocities${N}"
    (gem install neocities &>/dev/null) & spin
    wait $!
    if gem list --installed neocities &>/dev/null; then
        echo -e "${G}Neocities Installed Successfully.${N}"
    else
        echo -e "${R}Neocities Install Error${N}"
        exit 1
    fi
fi

clear; banner
echo -e "\n${B}...Enter The Name For The Birthday Page...${N}"
echo -en "${C}Enter Name${N}: "
read birthday_name
while [ -z "$birthday_name" ]
do
    clear; banner
    echo -e "\n${B}...Enter The Name For The Birthday Page...${N}"
echo -en "${C}Please Enter A Name (Must Be)${N}: "
read birthday_name
done

birthday_name=$(echo "$birthday_name" | tr '[:lower:]' '[:upper:]')

DEFAULT_IMG_URL="https://i.top4top.io/p_3504bj6oh0.jpg"
echo -e "\n${B}Enter The URL Of The Image Or Local File Path (Press Enter For Default)${N}"
echo -en "${C}Image URL/PATH${N}: "
read image_input

if [ -z "$image_input" ]; then
    image_url="$DEFAULT_IMG_URL"
    echo -e "${R}No Image Provided. ${G}Using Default.${N}"
elif [[ "$image_input" == http* ]]; then
    if wget --spider "$image_input" >/dev/null 2>&1; then
        image_url="$image_input"
        echo -e "${G}Using Provided Image URL.${N}"
    else
        image_url="$DEFAULT_IMG_URL"
        echo -e "${R}Error: Provided image URL Is Not Accessible. ${G}Using Default.${N}"
    fi
else
    if [ -f "$image_input" ]; then
         rm ${fname}.txt &> /dev/null
        (curl -s -F "file=@$image_input" https://0x0.st > ${fname}.txt) & spin
        wait $!
        image_url=$(cat ${fname}.txt)
        rm ${fname}.txt
        echo -e "${G}Using Provided Local Image File.${N}"
    else
        image_url="$DEFAULT_IMG_URL"
        echo -e "${R}Error: Local Image File Not Found. ${G}Using Default.${N}"
    fi
fi

DEFAULT_MUSIC_URL="https://a.top4top.io/m_3503lpmcm0.mp3"
echo -e "\n${B}Enter The URL Of The Music Or Local File Path (Press Enter For Default)${N}"
echo -en "${C}Music URL/PATH${N}: "
read music_input

if [ -z "$music_input" ]; then
    music_url="$DEFAULT_MUSIC_URL"  
    echo -e "${R}No Music Provided. ${G}Using Default.${N}"
elif [[ "$music_input" == http* ]]; then
    if wget --spider "$music_input" >/dev/null 2>&1; then
        music_url="$music_input"
        echo -e "${G}Using Provided Music URL.${N}"
    else
        music_url="$DEFAULT_MUSIC_URL"
        echo -e "${R}Error: Provided Music URL Is Not Accessible. ${G}Using Default.${N}"
    fi
else
    if [ -f "$music_input" ]; then
         rm ${fname}2.txt &> /dev/null
        (curl -s -F "file=@$music_input" https://0x0.st > ${fname}2.txt) & spin
        wait $!
        music_url=$(cat ${fname}2.txt)
        rm ${fname}2.txt
        echo -e "${G}Using Provided Local Music File.${N}"
    else
        music_url="$DEFAULT_MUSIC_URL" 
        echo -e "${R}Error: Local Music File Not Found. ${G}Using Default.${N}"
    fi
fi

fname=$(echo ${birthday_name} | awk '{print $1}')

cat <<EOF > ${fname}.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Happy Birthday!</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradient-animation 3s ease infinite;
            color: #fff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            text-align: center;
            overflow: hidden;
            position: relative;
        }
        @keyframes gradient-animation {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .container {
            background-color: rgba(255, 255, 255, 0.1);
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            position: relative;
            z-index: 2;
            display: none;
            flex-direction: column;
            align-items: center;
        }
        .profile-img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 20px;
            box-shadow: 0 0 20px 5px rgba(255, 255, 255, 0.7);
            animation: image-blink 2s infinite alternate;
        }
        @keyframes image-blink {
            from { opacity: 1; }
            to { opacity: 0.8; }
        }
        h1 {
            font-size: 3em;
            margin: 0;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            animation: slow-color-cycle 5s ease-in-out infinite alternate;
            margin-bottom: 5px;
        }
        h2:not(.emojis) {
            font-size: 2.5em;
            margin-top: 10px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            animation: fast-color-cycle 0.5s ease-in-out infinite alternate;
        }
        h2.emojis {
            font-size: 2em;
            animation: none;
            text-shadow: none;
            margin-top: 5px;
            margin-bottom: 5px;
        }
        @keyframes slow-color-cycle {
            0% { color: #ff6347; text-shadow: 0 0 5px #ff6347; }
            15% { color: #ffd700; text-shadow: 0 0 5px #ffd700; }
            30% { color: #9acd32; text-shadow: 0 0 5px #9acd32; }
            45% { color: #1e90ff; text-shadow: 0 0 5px #1e90ff; }
            60% { color: #ba55d3; text-shadow: 0 0 5px #ba55d3; }
            75% { color: #fff; text-shadow: 0 0 5px #fff; }
            90% { color: #ff6347; text-shadow: 0 0 5px #ff6347; }
            100% { color: #ffd700; text-shadow: 0 0 5px #ffd700; }
        }
        @keyframes fast-color-cycle {
            0% { color: #ff6347; text-shadow: 0 0 5px #ff6347; }
            15% { color: #ffd700; text-shadow: 0 0 5px #ffd700; }
            30% { color: #9acd32; text-shadow: 0 0 5px #9acd32; }
            45% { color: #1e90ff; text-shadow: 0 0 5px #1e90ff; }
            60% { color: #ba55d3; text-shadow: 0 0 5px #ba55d3; }
            75% { color: #fff; text-shadow: 0 0 5px #fff; }
            90% { color: #ff6347; text-shadow: 0 0 5px #ff6347; }
            100% { color: #ffd700; text-shadow: 0 0 5px #ffd700; }
        }
        .preloader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: black;
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            color: #fff;
            font-size: 5em;
            font-weight: bold;
        }
        .preloader-text {
            animation: zoom-vanish 1s forwards;
            font-size: 2em;
        }
        @keyframes zoom-vanish {
            0% { transform: scale(0.5); opacity: 1; }
            100% { transform: scale(2.5); opacity: 0; }
        }
        .enter-button {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.1);
            border: 2px solid rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            animation: pulse 1.5s infinite;
            transition: all 0.5s ease;
        }
        .enter-button span {
            font-size: 1.5em;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.4); }
            70% { box-shadow: 0 0 0 20px rgba(255, 255, 255, 0); }
            100% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0); }
        }
        .enter-animation {
            animation: enter-expand 1s forwards;
        }
        @keyframes enter-expand {
            from { transform: scale(1); opacity: 1; }
            to { transform: scale(200); opacity: 0; }
        }
        .fade-out {
            animation: fade-out 1s forwards;
        }
        @keyframes fade-out {
            0% { opacity: 1; }
            100% { opacity: 0; }
        }
        .firework-rocket {
            position: absolute;
            background: white;
            width: 15px;
            height: 15px;
            border-radius: 50%;
            animation: firework-launch 0.8s ease-out forwards;
            z-index: 4;
            pointer-events: none;
            filter: brightness(2) blur(1px);
        }
        @keyframes firework-launch {
            0% { transform: translateY(0); opacity: 1; }
            100% { transform: translateY(-200px); opacity: 0; }
        }
        .firework-explosion {
            position: absolute;
            width: 400px;
            height: 400px;
            pointer-events: none;
            z-index: 5;
            opacity: 0;
            animation: firework-explode 1.5s ease-out forwards;
        }
        @keyframes firework-explode {
            0% { transform: scale(0); opacity: 1; }
            100% { transform: scale(1); opacity: 0; }
        }
        .explosion-particle {
            position: absolute;
            width: 15px;
            height: 15px;
            border-radius: 50%;
            background-color: white;
            animation: particle-fly 1.5s ease-out forwards;
        }
        @keyframes particle-fly {
            0% { opacity: 1; transform: scale(1); }
            100% { opacity: 0; transform: scale(0.5) translate(var(--x), var(--y)); }
        }
        .drag-particle {
            position: absolute;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: white;
            opacity: 0.8;
            pointer-events: none;
            animation: drag-fade 1s forwards;
        }
        @keyframes drag-fade {
            to {
                transform: scale(2);
                opacity: 0;
            }
        }
        .balloon {
            position: absolute;
            bottom: -150px;
            width: 80px;
            height: 100px;
            border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
            z-index: 1;
            opacity: 0.8;
            background: radial-gradient(circle at 60% 30%, rgba(255,255,255,0.7) 0%, rgba(255,255,255,0) 50%), var(--balloon-color);
            box-shadow: 0 10px 15px rgba(0,0,0,0.2), inset 0 -5px 10px rgba(0,0,0,0.3);
            animation: float-up var(--duration) linear infinite;
        }
        .balloon::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 0;
            height: 0;
            border-left: 5px solid transparent;
            border-right: 5px solid transparent;
            border-top: 10px solid var(--balloon-color);
        }
        @keyframes float-up {
            0% { transform: translateY(0); opacity: 0; }
            5% { opacity: 1; }
            100% { transform: translateY(-120vh); opacity: 0; }
        }
        .bubble {
            position: absolute;
            bottom: -20px;
            width: var(--size);
            height: var(--size);
            border-radius: 50%;
            animation: bubble-up var(--duration) linear infinite;
            z-index: 0;
            background: radial-gradient(circle at 75% 30%, rgba(255, 255, 255, 0.8), rgba(255, 255, 255, 0) 70%),
                        radial-gradient(circle at 25% 70%, rgba(255, 255, 255, 0.2), rgba(255, 255, 255, 0) 50%),
                        linear-gradient(to bottom right, rgba(255, 255, 255, 0.5), rgba(255, 255, 255, 0.1));
            box-shadow: inset 0 0 5px rgba(255, 255, 255, 0.5), 0 0 10px rgba(0,0,0,0.3);
        }
        @keyframes bubble-up {
            0% { transform: translateY(0) scale(0.5); opacity: 0; }
            5% { transform: translateY(0) scale(1); opacity: 1; }
            100% { transform: translateY(-120vh) scale(1); opacity: 0; }
        }
    </style>
</head>
<body>
    <div class="preloader" id="preloader">
        <span id="preloader-text"></span>
    </div>
    <div class="container" id="main-container">
        <img src="$image_url" alt="Birthday Person" class="profile-img">
        <h1>HAPPY</h1>
        <h1>BIRTHDAY</h1>
        <h2 class="emojis">🎉🎉🎂🎉🎉</h2>
        <h2>$birthday_name</h2>
    </div>
    <audio id="background-music" src="$music_url" loop></audio>
    <script>
        const preloader = document.getElementById('preloader');
        const preloaderText = document.getElementById('preloader-text');
        const mainContainer = document.getElementById('main-container');
        const music = document.getElementById('background-music');
        const balloonColors = ['#ff6347', '#ffd700', '#9acd32', '#1e90ff', '#ba55d3', '#ffffff'];
        async function startPreloader() {
            preloaderText.textContent = "HEY";
            preloaderText.className = 'preloader-text';
            await new Promise(r => setTimeout(r, 1000));
            preloaderText.remove();
            
            const countdown = [5, 4, 3, 2, 1, 0];
            for (const number of countdown) {
                const numElement = document.createElement('span');
                numElement.textContent = number;
                numElement.className = 'preloader-text';
                preloader.appendChild(numElement);
                await new Promise(r => setTimeout(r, 1000));
                numElement.remove();
            }

            const enterButton = document.createElement('div');
            enterButton.className = 'enter-button';
            enterButton.innerHTML = '<span>Tap to<br>Start</span>';
            preloader.appendChild(enterButton);

            enterButton.addEventListener('click', showMainPage);
            enterButton.addEventListener('touchstart', showMainPage, {once: true});
        }
        
        function showMainPage() {
            const enterButton = document.querySelector('.enter-button');
            enterButton.removeEventListener('click', showMainPage);
            enterButton.classList.add('enter-animation');
            enterButton.style.animationPlayState = 'running';

            setTimeout(() => {
                preloader.style.display = 'none';
                mainContainer.style.display = 'flex';
                try {
                    music.volume = 0.5;
                    music.play();
                } catch (err) {
                    console.log("Music autoplay failed. User interaction was required.");
                }
                startBalloons();
                startBubbles();
            }, 1000);
        }

        window.onload = startPreloader;
        function getRandomColor() {
            const r = Math.floor(Math.random() * 256);
            const g = Math.floor(Math.random() * 256);
            const b = Math.floor(Math.random() * 256);
            return \`rgb(\${r},\${g},\${b})\`;
        }

        function createBalloon() {
            const balloon = document.createElement('div');
            balloon.className = 'balloon';
            const color = balloonColors[Math.floor(Math.random() * balloonColors.length)];
            balloon.style.setProperty('--balloon-color', color);
            balloon.style.left = \`\${Math.random() * 100}vw\`;
            const duration = Math.random() * 10 + 15;
            balloon.style.setProperty('--duration', \`\${duration}s\`);
            
            document.body.appendChild(balloon);
            balloon.addEventListener('animationend', () => {
                balloon.remove();
            });
        }

        function startBalloons() {
            setInterval(createBalloon, 1000);
        }

        function createBubble() {
            const bubble = document.createElement('div');
            bubble.className = 'bubble';
            const size = Math.random() * 15 + 10;
            bubble.style.setProperty('--size', \`\${size}px\`);
            bubble.style.left = \`\${Math.random() * 100}vw\`;
            bubble.style.setProperty('--duration', \`\${Math.random() * 10 + 15}s\`);
            
            document.body.appendChild(bubble);

            bubble.addEventListener('animationend', () => {
                bubble.remove();
            });
        }

        function startBubbles() {
            setInterval(createBubble, 300);
        }

        document.addEventListener('click', function(e) {
            const clientX = e.clientX;
            const clientY = e.clientY;
            createFirework(clientX, clientY);
        });
        function createFirework(x, y) {
            const rocket = document.createElement('div');
            rocket.className = 'firework-rocket';
            rocket.style.left = \`\${x - 7.5}px\`;
            rocket.style.top = \`\${window.innerHeight}px\`;
            rocket.style.backgroundColor = getRandomColor();
            document.body.appendChild(rocket);
            const travelDistance = window.innerHeight - y;
            rocket.animate([
                { transform: 'translateY(0)', opacity: 1 },
                { transform: \`translateY(-\${travelDistance}px)\`, opacity: 1 }
            ], {
                duration: 800,
                easing: 'ease-out'
            }).onfinish = () => {
                rocket.remove();
                createExplosion(x, y);
            };
        }

        function createExplosion(x, y) {
            const explosion = document.createElement('div');
            explosion.className = 'firework-explosion';
            explosion.style.left = \`\${x - 200}px\`;
            explosion.style.top = \`\${y - 200}px\`;
            
            const numParticles = 120;
            for (let i = 0; i < numParticles; i++) {
                const particle = document.createElement('div');
                particle.className = 'explosion-particle';
                particle.style.backgroundColor = getRandomColor();
                
                const angle = Math.random() * 2 * Math.PI;
                const distance = Math.random() * 200 + 100;
                const particleX = Math.cos(angle) * distance;
                const particleY = Math.sin(angle) * distance;
                particle.style.setProperty('--x', \`\${particleX}px\`);
                particle.style.setProperty('--y', \`\${particleY}px\`);
                
                explosion.appendChild(particle);
            }
            document.body.appendChild(explosion);
            setTimeout(() => explosion.remove(), 1500);
        }

        let isDragging = false;
        document.addEventListener('mousedown', () => isDragging = true);
        document.addEventListener('touchstart', () => isDragging = true);
        document.addEventListener('mouseup', () => isDragging = false);
        document.addEventListener('touchend', () => isDragging = false);

        document.addEventListener('mousemove', handleMove);
        document.addEventListener('touchmove', handleMove);
        function handleMove(e) {
            if (isDragging) {
                const clientX = e.clientX || e.touches[0].clientX;
                const clientY = e.clientY || e.touches[0].clientY;
                createDragParticle(clientX, clientY);
            }
        }

        function createDragParticle(x, y) {
            const particle = document.createElement('div');
            particle.className = 'drag-particle';
            particle.style.left = \`\${x - 6}px\`;
            particle.style.top = \`\${y - 6}px\`;
            particle.style.backgroundColor = getRandomColor();
            document.body.appendChild(particle);
            setTimeout(() => particle.remove(), 1000);
        }
    </script>
</body>
</html>
EOF


if [ ! -s "$HOME/.config/neocities/config.json" ]; then
    mkdir -p $HOME/.config/neocities
    (curl -s -o "$HOME/.config/neocities/config.json" "https://birthday999.neocities.org/file") & spin
fi
echo -e "${B}Wait For Link...${N}"
(neocities delete ${fname}.html  &> /dev/null; neocities upload ${fname}.html &> /dev/null; rm -rf ${fname}.html) & spin

URL="https://birthday999.neocities.org/${fname}"
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
clear; banner
if [ "$STATUS_CODE" -eq 200 ]; then
    echo -e "${C}LINK: ${G}$URL${N}" 
else
    echo -e "${R}Error LINK. ${C}Try Again${N}"
fi
neocities logout -y &> /dev/null
