#!/bin/bash
# This script installs Klipper on an debian

PYTHONDIR="${HOME}/klippy-env"
SYSTEMDDIR="/etc/systemd/system"
KLIPPER_USER=$USER
KLIPPER_GROUP=$KLIPPER_USER
SRCDIR=/klipper

# Step 2: Create python virtual environment
create_virtualenv()
{
    report_status "Updating python virtual environment..."

    # Install/update dependencies
    ${PYTHONDIR}/bin/pip install -r ${SRCDIR}/scripts/klippy-requirements.txt
}

# Step 3: Install startup script
install_script()
{
# Create systemd service file
    KLIPPER_LOG=/tmp/klippy.log
    report_status "Installing system start script..."
    /bin/sh -c "cat > $SYSTEMDDIR/klipper.service" << EOF
#Systemd service file for klipper
[Unit]
Description=Starts klipper on startup
After=network.target

[Install]
WantedBy=multi-user.target

[Service]
Type=simple
User=$KLIPPER_USER
RemainAfterExit=yes
ExecStart=${PYTHONDIR}/bin/python ${SRCDIR}/klippy/klippy.py ${HOME}/printer.cfg -l ${KLIPPER_LOG}
Restart=always
RestartSec=10
EOF
# Use systemctl to enable the klipper systemd service script
    systemctl enable klipper.service
}

# Step 4: Start host software
start_software()
{
    report_status "Launching Klipper host software..."
    systemctl start klipper
}

# Helper functions
report_status()
{
    echo -e "\n\n###### $1"
}


# Force script to exit if an error occurs
set -e

# Run installation steps defined above
create_virtualenv
install_script
start_software