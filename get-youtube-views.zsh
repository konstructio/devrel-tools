#!/bin/zsh

#
# This script is used to retrieve the number of views from YouTube videos.
# Useful when you need to regularly views from videos on channels you don't have
# admin access to check YouTube statistics or when you don't need that level of
# details.
#
# To do so, you need to add the videos in the EXTERNAL_VIDEOS variable. See the
# variable comment for more information on the format.
#
# Dependencies: yt-dlp https://github.com/yt-dlp/yt-dlp
#

#
# Each entry contain the name of the video for an output that will make sense
#
# The format is "VIDEONAME[SPACE]VIDEOURL".
#
# Since it's not possible to have multidimensional arrays in ZSH, and using two
# arrays could cause human missmatch errors between the name of the video and
# URL, it is the simplest way. The split will be made with https://
#
EXTERNAL_VIDEOS=(
    "Breaking the Silos - GitOps Strategies through Kubefirst https://www.youtube.com/watch?v=om1rxvKJe3M"
    "Cisco CloudUnfiltered - Kubefirst - Kubernetes CI/CD should be easy! https://www.youtube.com/watch?v=Jnk8ac6Bu88"
    "Civo - Kubernetes Unpacked: Embracing GitOps & Best-Practice Tools with Kubefirst https://www.youtube.com/watch?v=03dAJ3in8wM"
    "Cloud Native Islamabad - Kubefirst (Hands-On Intro) https://www.youtube.com/watch?v=sg4APL87vZc"
    "Cloud Native Podcast - GitOps with Kubefirst deploy and iterate faster | Ep 77 https://www.youtube.com/watch?v=OIJqNX-jQTc"
    "Conf42Cast - Beyond Kubernetes | John Dietz, Jared Edwards & Miko Pawlikowski https://www.youtube.com/watch?v=H17k5GEBD8U"
    "GitHub - Open Source Friday with Kubefirst https://www.youtube.com/watch?v=FEmb12t6i6Y"
    "Kubernetes Bytes - Accelerating Kubernetes Adoption: Unleashing the Power of GitOps using Kubefirst https://www.youtube.com/watch?v=CSGF9VgYmXk"
    "KubeSkills - Growing in Open Source with KubeFirst https://www.youtube.com/watch?v=NMZxuazgaRM"
    "Kubeshop - Argo CD Best Practices & Practical Patterns https://www.youtube.com/live/CJQBtDYA_44?si=kpFrE4iEs0dvmzTN"
    "Kubeshop - Civo Marketplace & kubefirst: a match made in heaven https://www.youtube.com/live/T-CHcmW2PcU"
    "Kubeshop - Deep Dive on HashiCorp Terraform & Atlantis https://www.youtube.com/live/moBZzQtr-AE"
    "Kubeshop - Deep dive on kubefirst SSO & OIDC https://www.youtube.com/live/MydnSl8M1x4"
    "Kubeshop - Deep Dive on metaphor: the kubefirst platform exploration application https://www.youtube.com/live/scJsS51AVB8"
    "Kubeshop - Implementing observability on kubefirst with Datadog https://www.youtube.com/live/jgrxcfSduJY"
    "Kubeshop - Infrastructure automation: Terraform with Atlantis vs Crossplane https://www.youtube.com/live/JgUMmL4ixjE"
    "Kubeshop - Integrating Argo Workflows with GitHub Actions & GitLab CI https://www.youtube.com/live/4VrgjdlpCmo"
    "Kubeshop - k3d: the heart of kubefirst's local platform https://www.youtube.com/live/auNB_AhdC6E"
    "Kubeshop - Kubefirst - Instant GitOps platform gets an amazing User Interface https://www.youtube.com/live/8_x2exCOI-0"
    "Kubeshop - Kubefirst 1.8 Release https://www.youtube.com/live/2sFdz21JQ7c"
    "Kubeshop - Kubefirst 101: After Install - Kubernetes Infrastructure Management GitOps Platform https://youtu.be/KEUOaNMUqOM"
    "Kubeshop - kubefirst 2.0.0 release livestream, with Civo https://www.youtube.com/live/7ZKrWtyYTgY"
    "Kubeshop - Kubefirst v1.10 release & other awesomeness https://www.youtube.com/live/cjbWbyWCI4Q"
    "Kubeshop - Kubefirst v1.9 Release- Github, Hashicorp Vault and Admin Console https://www.youtube.com/live/6OwLwN_G9D0"
    "Kubeshop - Kyverno: a policy engine designed for Kubernetes https://www.youtube.com/live/jfhQBX0nYDc"
    "Kubeshop - Let's talk HashiCorp Vault https://www.youtube.com/live/vczxh0SH5Hk?si=lqIexZb8RTQuZiFC"
    "Kubeshop - Monitor & Act on Your Kubernetes Cluster With Botkube https://www.youtube.com/live/WMFYDKsJSSs"
    "Kubeshop - Monitor & reduce Kubernetes spend with OpenCost https://www.youtube.com/live/6sgPIgEuBo8"
    "Kubeshop - Musing on platform engineering & cloud native trends with Abby Bangser https://www.youtube.com/live/_mdKsBLEPXg"
    "Kubeshop - Reloader: live reloading made easy https://www.youtube.com/live/svTLVfkOPn0"
    "Kubeshop - Taking Ownership of the kubefirst's Argo Workflows https://www.youtube.com/live/FQ12w8d3oSo"
    "Kubeshop - Testkube: orchestrate your tests natively on Kubernetes https://www.youtube.com/live/D5HF3iYphyQ"
    "Kubeshop - The kubefirst Trifecta: NGINX Ingress Controller, cert-manager & external-dns https://www.youtube.com/watch?v=8Lkb4cr3aIw"
    "Kubeshop - v1.11 Release - Kubefirst Local update, Improved Vault support https://www.youtube.com/live/dnb8PkstC0Y"
    "Kubeshop - vcluster: fully functional virtual Kubernetes clusters & how they works https://www.youtube.com/live/1sSJk6i0nB8"
    "Kubeshop - From GitLab SaaS to GitLab self-managed on kubefirst https://www.youtube.com/watch?v=3YPg7-SIpPE"
    "Kubeshop - Adding applications to the kubefirst GitOps Catalog https://www.youtube.com/watch?v=ncKNvqJUrd4"
    "Kubeshop - Deep dive on External Secrets Operator with Vault & using other providers https://www.youtube.com/watch?v=99r5QNwRh1M"
    "Kubeshop - Get your resource requests "Just Right" with Goldilocks https://www.youtube.com/watch?v=DFwUfPVf1Ak"
)

YELLOW="\033[1;93m"
NOFORMAT="\033[0m"
BOLD="\033[1m"

# Check if yt-dlp is installed
if [[ $(which yt-dlp | grep "not found" ) ]] ; then
    print "Please install $YELLOWyt-dlp$NOFORMAT (see https://github.com/yt-dlp/yt-dlp for instructions) and run the script again."
else
    # Fetching information from each videos
    print
    for video in "$EXTERNAL_VIDEOS[@]"; do
        name=${video%*https*}
        url="https://"${video#*https://*}

        views=$(yt-dlp -j "$url" | jq -r '.["view_count"]')
        echo "$YELLOW$name:$NOFORMAT $BOLD$views"
    done
    print
fi
