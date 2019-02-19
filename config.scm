(use-modules
 (gnu)
 (gnu system nss)
 (gnu services ssh)
 (gnu packages ssh)
 (gnu packages linux)
 (gnu packages xorg)
 (gnu packages spice)
 (gnu packages wm)
 (gnu packages xdisorg)
 (gnu packages shells)
 (gnu packages version-control)
 (gnu packages golang))
(use-service-modules desktop)
(use-package-modules certs gnome)

(operating-system
  (host-name "guix")
  (timezone "Europe/Minsk")
  (locale "ru_RU.utf8")

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (target "/dev/sda")))

  (file-systems (cons (file-system
                        (device (file-system-label "root"))
                        (mount-point "/")
                        (type "btrfs")
                        )
                      %base-file-systems))

  (users (cons (user-account
                (name "difrex")
                (comment "")
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video"))
                (home-directory "/home/difrex"))
               %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages (cons* nss-certs         ;for HTTPS access
                   gvfs              ;for user mounts
		   gpm
		   git
		   openssh
		   spice
		   spice-protocol
		   xf86-video-qxl
		   i3-wm
		   zsh
		   rofi
		   go
                   %base-packages))

  ;; Add GNOME and/or Xfce---we can choose at the log-in
  ;; screen with F1.  Use the "desktop" services, which
  ;; include the X11 log-in service, networking with
  ;; NetworkManager, and more.
  (services (cons* (gnome-desktop-service)
                   %desktop-services))
;;		   (login-service (login-configuration "motd"
;;						       "GuixSD. You are welcome."))
		 

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss)

  (issue "This is GUIX!!!\n"))
