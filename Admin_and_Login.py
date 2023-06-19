from calendar import different_locale
from mimetypes import init
import streamlit as st
import plotly.express as px
import pandas as pd
import seaborn as sns
from PIL import Image
import numpy as np # np mean, np random 
import time # to simulate a real time data, time loop 
import plotly.express as px # interactive charts
import tkinter as tk
from tkinter import filedialog
import os
from tkinter import ttk
import seedir as sd
from contextlib import contextmanager, redirect_stdout
from io import StringIO
from time import sleep
import subprocess
import openai
import streamlit.components.v1 as stc
import sqlite3
import hashlib

conn = sqlite3.connect('data.db',check_same_thread=False)
c = conn.cursor()

def create_admin_table():
    c.execute('CREATE TABLE IF NOT EXISTS admintable(username TEXT, email TEXT, password TEXT)')

def edit_admin(new_username,new_email,new_password):
	c.execute('UPDATE admintable SET username =?,email=?,password=?',(new_username,new_email,new_password))
	conn.commit()
	data = c.fetchall()
	return data

def login_admin(username,password):
	c.execute('SELECT * FROM admintable WHERE username =? AND password = ?',(username,password))
	data = c.fetchall()
	return data

def get_admin(username):
	c.execute('SELECT * FROM admintable WHERE username="{}"'.format(username))
	data = c.fetchall()
	return data

def view_admin():
	c.execute('SELECT * FROM admintable')
	data = c.fetchall()
	return data

def create_user_table():
	c.execute('CREATE TABLE IF NOT EXISTS usertable(username TEXT,email TEXT,password TEXT,github_username TEXT,github_password TEXT,docker_username TEXT,docker_password TEXT,open_ai_api TEXT,activity TEXT, time TEXT)')


def add_admin(username,email,password):
	c.execute('INSERT INTO admintable(username,email,password) VALUES (?,?,?)',(username,email,password))
	conn.commit()

def add_user(username,email,password,github_username,github_password,docker_username,docker_password,open_ai_api):
	c.execute('INSERT INTO usertable(username,email,password,github_username,github_password,docker_username,docker_password,open_ai_api) VALUES (?,?,?,?,?,?,?,?)',(username,email,password,github_username,github_password,docker_username,docker_password,open_ai_api))
	conn.commit()
        
def view_all_user():
	c.execute('SELECT username, email, github_username, docker_username FROM usertable')
	data = c.fetchall()
	return data

def login_user(username,password):
	c.execute('SELECT * FROM usertable WHERE username =? AND password = ?',(username,password))
	data = c.fetchall()
	return data

def view_all_user_activity():
	c.execute('SELECT DISTINCT username AND activity AND time FROM usertable')
	data = c.fetchall()
	return data

def delete_data(username):
	c.execute('DELETE FROM usertable WHERE username="{}"'.format(username))
	conn.commit()
        
def make_hashes(password):
	return hashlib.sha256(str.encode(password)).hexdigest()

def check_hashes(password,hashed_text):
	if make_hashes(password) == hashed_text:
		return hashed_text
	return False

HTML_BANNER = """
    <div style="background-color:#464e5f;padding:10px;border-radius:10px">
    <h1 style="color:white;text-align:center;">Dev-Automation-Script(dash)</h1>
    <p style="color:white;text-align:center;">Automate Development</p>
    </div>
    """

def chat_with_chatgpt(prompt, model="gpt-3.5-turbo"):
    response = openai.Completion.create(
        engine=model,
        prompt=prompt,
        max_tokens=100,
        n=1,
        stop=None,
        temperature=0.5,
    )

    message = response.choices[0].text.strip()
    return message

def main():

    create_admin_table()
    create_user_table()

    stc.html(HTML_BANNER)

    #image = Image.open('logo.png')

    #st.image(image, use_column_width=True)

    menu = ["Intro", "Admin Panel", "Sign-Up", "Sign-In"]
    choice = st.sidebar.selectbox("Select Activity", menu)
    if choice == "Intro":
        st.subheader("Intro")
        # new_admin_username = st.text_input("Username")
        # new_admin_email = st.text_input("Email")
        # new_admin_password = st.text_input("Password",type='password')
        # if st.button("Signup"):
            # create_admin_table()
            # add_admin(new_admin_username,new_admin_email,make_hashes(new_admin_password))
            # st.success("You have successfully created a valid Account")
            # st.info("Go to Sign-In Menu to login")

    elif choice == "Admin Panel":
        st.subheader("Admin Panel")
        username = st.text_input("User Name")
        password = st.text_input("Password",type='password')
        if st.button("Login"):
            create_admin_table()
            hashed_pswd = make_hashes(password)
            result = login_admin(username,check_hashes(password,hashed_pswd))
            if not result:

                st.warning("Incorrect Username/Password")
            
            else:
                st.success("Logged In as {}".format(username))
                process = subprocess.Popen (['streamlit','run', 'AdminPanel.py'],shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                result = process.communicate( )


    elif choice == "Sign-Up":
        st.subheader("Sign-Up using credentials")
        new_username = st.text_input("Username")
        new_email = st.text_input("Email")
        new_password = st.text_input("Password",type='password')
        new_github_username = st.text_input("GitHub Username")
        new_github_password = st.text_input("GitHub Password", type='password')
        new_docker_username = st.text_input("Docker Username")
        new_docker_password = st.text_input("Docker Password", type= "password")
        new_open_ai_api = st.text_input("Open AI api")
        if st.button("Signup"):
            create_user_table()
            add_user(new_username,new_email,make_hashes(new_password),new_github_username,make_hashes(new_github_password),new_docker_username,make_hashes(new_docker_password),new_open_ai_api)
            st.success("You have successfully created a valid Account")
            st.info("Go to Sign-In Menu to login")

    elif choice == "Sign-In":
        username = st.text_input("User Name")
        password = st.text_input("Password",type='password')
        if st.button("Login"):
            create_user_table()
            hashed_pswd = make_hashes(password)
            result = login_user(username,check_hashes(password,hashed_pswd))
            if not result:
                st.warning("Incorrect Username/Password")
            
            else:
                st.success("Logged In as {}".format(username))
                process = subprocess.Popen (['streamlit', 'run', "Git-Automation-Script.py"],shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                result = process.communicate( )
   
if __name__ == '__main__':
    main()