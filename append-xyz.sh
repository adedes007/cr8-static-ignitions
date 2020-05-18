#export ifcfgens192=`base64 ifcfg-ens192`
#export resolvconf=`base64 ../resolv.conf`

base64 -w0 < ifcfg-ens192      >ifcfgens192.64
base64 -w0 < ../resolv.conf    >resolvconf.64
export hostnameNode=`echo $1.ocp50.example.com | base64`
echo $hostnameNode       >hostnameNode.64

rm *.json
cat <<EOF > append_$1.json
{
    "ignition": {
        "version": "2.2.0",
        "config": {
            "append": [
                {
                    "source": "http://10.0.50.222:8080/ignition/$1.ign",
                    "verification": {}
                }
            ]
        }
    },
    "networkd": {},
    "passwd": {},
    "storage": {
        "files": [
            {
                "filesystem": "root",
                "path": "/etc/sysconfig/network-scripts/ifcfg-ens192",
                "contents": {
                    "source": "data:;base64,`cat ifcfgens192.64`",
                    "verification": {}
                },
                "mode": 420
            },
            {
                "filesystem": "root",
                "path": "/etc/resolv.conf",
                "contents": {
                    "source": "data:;base64,`cat resolvconf.64`",
                    "verification": {}
                },
                "mode": 420
            },
            {
                "filesystem": "root",
                "path": "/etc/hostname",
                "contents": {
                    "source": "data:;base64,`cat hostnameNode.64`",
                    "verification": {}
                },
                "mode": 420
            }
        ]
    },
    "systemd": {}
}

EOF

rm *.64
