#! /bin/bash

### Git Automation Script for automating git and docker ###
### Created by PIYUSH-MISHRA-00 ###

while :
do
echo
echo "Which operation you want to perform ?"
echo
echo -e "\t(0) GitHub"
echo -e "\t(1) Docker"
echo -e "\t(2) Quit"
echo -n "Enter your choice [0-3]: "

read operation
export operation

case $operation in


0) while :
   do
   echo
   echo "Which Git operation you want to perform ?"
   echo
   echo "GitHub username: $username"
   echo "Local repository name: $local_repo"
   echo "Remote repository name: $remote"
   echo "The default branch you want to work with: $branch"
   echo "GPG key value: $GPG"
   echo
   echo -e "\t(0) Configure (configures the script for continuous uses)"
   echo -e "\t(1) Clone"
   echo -e "\t(2) Pull"
   echo -e "\t(3) Push"
   echo -e "\t(4) Generate Patch"
   echo -e "\t(5) Send Email"
   echo -e "\t(6) Return to Main Menu"
   echo -n "Enter your choice [0-6]: "
   read choice

   case $choice in

   0) echo "Enter the values for future use of the script..."
      echo
      echo "Enter GitHub username: "
      read username
      export username
      echo "Your username is: $username"
      echo
      echo "Local repository name: "
      read local_repo
      export local_repo
      echo "Your local repository name is: $local_repo"
      echo 
      echo "Remote repository name: "
      read remote
      export remote
      echo "Remote repository name is: $remote"
      echo
      echo "The default branch you want to work with: "
      read branch
      export branch
      echo "The default branch you want to work with: $branch"
      echo
      echo "GPG key value is: $GPG"
      echo
      echo "GPG key id for signed commits(leave blank if you don't want signed commits)"
      read GPG
      export GPG
      echo "GPG key value is: $GPG"
      echo
      ;;

   1) echo "Cloning from GitHub"
      echo
      echo "Enter the repository https url: "
      read clone_url
      git clone $echo $clone_url;;

   2) echo "Pulling from GitHub"
      echo
      echo "Enter the repository https url: "
      read pull_url
      echo
      echo $pull_url
      echo
      while :
      do
      echo "Which type of Git Pull you want ?"
      echo -e "\t(1) Merge (the default strategy)"
      echo -e "\t(2) Rebase"
      echo -e "\t(3) Fast-forward only"
      echo -e "\t(4) Return to main menu"
      echo -n "Enter your choice [1-4]: "
      read pull_choice
      case $pull_choice in
      1) 
      git config pull.rebase false 
      git pull $echo "$pull_url";;
      2) 
      git config pull.rebase true 
      git pull $echo "$pull_url";;
      3) 
      git config pull.ff only 
      git pull $echo "$pull_url";;
      4)
      break
      ;;
         *) 
         echo "Invalid operation"
         ;;
      esac
      done
      ;;

   3) echo "Pushing to GitHub"
      echo
      while :
      do
      echo "Which type of Git Push you want ?"
      echo -e "\t(0) LFS (if git lfs is already installed into the system)"
      echo -e "\t(1) Normal"
      echo -e "\t(2) Return to main menu"
      echo -n "Enter your choice [0-2]: "
      read push_choice
      case $push_choice in
      0) 
      declare -A map

      map[$echo"$local_repo"] = $echo"$remote"

      git config --global user.name $echo"$username" 
      git config --global user.signingkey $echo$GPG 
      git init
      git lfs install
      echo
      echo "Enter the file extension without dot"
      read extension
      export extension
      git lfs track "*.$extension"
      git add .gitattributes
      git add .
      echo "Enter Commit message: "
      read message
      git commit -m $echo "$message"
      echo "Enter Tag name: (Press enter if you want to skip the tag name)"
      read tag
      echo "Enter Tag message: (Press enter if you want to skip the tag message)"
      read tag_message
      git tag -a $echo$tag -m "$echo$tag_message"
      git tag -n

      for i in "${!map[@]}"
         do
         git remote add $i https://github.com/$echo$username/${map[$i]}.git 
         git push -u $i $echo$branch 
         done

         git push;;

      1) 
      declare -A map

      map[$echo"$local_repo"] = $echo"$remote"

      git config --global user.name $echo"$username" 
      git config --global user.signingkey $echo$GPG 
      git init
      git add .
      echo "Enter Commit message: "
      read message
      git commit -m $echo "$message"
      echo "Enter Tag name: (Press enter if you want to skip the tag name)"
      read tag
      echo "Enter Tag message: (Press enter if you want to skip the tag message)"
      read tag_message
      git tag -a $echo$tag -m "$echo$tag_message"
      git tag -n

      for i in "${!map[@]}"
         do
         git remote add $i https://github.com/$echo$username/${map[$i]}.git 
         git push -u $i $echo$branch 
         done

         git push;;

      2)
      break
      ;;
         *) 
         echo "Invalid operation"
         ;;
      esac
      done
      ;; 


   4) echo "Generate Patch"
      echo "Enter file 1 and file 2"
      echo "Enter file 1"
      read fileone
      export fileone
      echo "Enter file2"
      read filetwo
      export filetwo
      diff $echo$fileone $echo$filetwo -staged
      echo "Enter the file name created using diff"
      read file_diff
      export file_diff
      git patch $file_diff
      ;; 

   5) echo "Send Email"
      echo "Enter the receiver... ??"
      read receiver
      echo "File you want to mail ??"
      read filename 
      git send-email --to=$receiver $filename
      ;;

   6)
   break
   ;;      


   *) echo "Invalid operation"
      ;;


   esac
   done
   ;;

1) while :
   do
   echo "Which type of Docker operation you want to perform ?"
   echo -e "\t(0) Login to the Docker Hub Repository"
   echo -e "\t(1) Pull an Image from Docker Hub"
   echo -e "\t(2) Build an Image"
   echo -e "\t(3) Run a Docker Image"
   echo -e "\t(4) Access the running container"
   echo -e "\t(5) Remove a Docker Container"
   echo -e "\t(6) Remove a Docker Image"
   echo -e "\t(7) Push an Image to the docker hub repository"
   echo -e "\t(8) Return to main menu"
   echo -n "Enter your choice [0-8]: "
   read dchoice
   case $dchoice in


   0)
   docker login
   ;;


   1)
   echo "Enter Image name: "
   read image_name
   export image_name
   echo "Enter tag if specific: "
   read pull_tag_name
   export pull_tag_name
   docker pull $image_name:$pull_tag_name
   ;;


   2) 
      while :
      do
      echo "Which docker build you want...?"
      echo -e "\t(0) Build from working directory "
      echo -e "\t(1) Build from URL"
      echo -e "\t(2) Return to main menu"
      echo -n "Enter your choice [0-2]: "
      read build_choice
      export build_choice
      case $build_choice in

      0)
      docker build .
      ;;

      1)
      echo "Enter the URL without "https://""
      read build_url
      export build_url
      docker build $build_url
      ;;

      2)
      break
      ;;      

      *) echo "Invalid operation"
      ;;
      
   esac
   done
   ;;

   3)
   echo "Enter image name you want to run: "
   read run_image
   export run_image
   docker run -it -d $run_image
   ;;
   4)
   docker login
   ;;
   5)
   echo "Enter Container ID to remove: "
   read container_id
   export container_id
   docker rm $container_id
   ;;
   6)
   echo "Enter Image ID to remove: "
   read image_id
   export image_id
   docker rmi $image_id
   ;;
   7)
   docker login
   echo "Enter Docker username: "
   read docker_username
   export docker_username
   echo "Enter docker image name you want to push: "
   read push_image_name
   export push_image_name
   docker push $docker_username/$push_image_name
   ;;
   8)
      break
      ;;
         *) 
         echo "Invalid operation"
         ;;
      esac
      done
      ;; 

2) echo "Quitting..."
      exit
      ;;

*) echo "Invalid operation"
      ;;

esac
done
;;
