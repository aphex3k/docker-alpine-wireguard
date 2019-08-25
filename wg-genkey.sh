#!/bin/sh
wg genkey | tee privatekey | wg pubkey > publickey