QUOTES=(
    "Girls are now preparing..."
    "Oh, is that so..."
    "Aah! The cat turned into a cat!"
    "My god, jelly donuts are so scary."
    "Genocide is just another game."
    "Unfortunately, I'm pretty good at dodging."
    "Whoa, so many books. I'll just borrow some later."
    "Being here in this place is equal to being dead."
    "Move and I'll shoot!!"
    "Wait, didn't you just say you didn't like sparrows"
    "I'm the strongest!"
    "Ayayayaya..."
    "So, what was I doing, again...?"
    "Youmu, it's not good to be so fussy."
    "Yeah, I'm insane to begin with."
    "...Whatever, I don't care anymore."
    "Are you smelling with your eyes?"
    "Do you find this brutal evening likable?"
    "You still are not invited, dear."
    "You're quite a talkative ghost."
    "Nobody's telling you to go home."
    "Then let the plundering begin!"
    "I've been in the basement. For about 495 years."
    "Don't take any books, please."
    "Stop following me already~"
    "I'm a normal person who just guards."
    "Are you the kind of person I can eat?"
    "Oh, me? Lessee, I'm Reimu Hakurei. Shrine maiden."
    "I'm really tasty."
    "By the way, who are you?"
    "Am I an alien ... ?"
    "You don't look human... - I am! ♥ (lies)"
    "Do you regret fighting me?"
    "I just don't think about losing."
    "All you did was add a cape..." 
    "Oh, an evil spirit? Wonderful!"
    
)

RANDOM=$$$(date +%s)
echo ${QUOTES[ $RANDOM % ${#QUOTES[@]} ]}

# socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
#     if [ `echo $line | awk -F '>>' '{print $1}'` == "workspace" ]; then
#         echo ${QUOTES[ $RANDOM % ${#QUOTES[@]} ]}
#     fi
# done
