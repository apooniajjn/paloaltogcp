#!/usr/bin/env python

from setuptools import setup

def readme():
    with open('README.md') as f:
        return f.read()

setup(name='spartan-palo-alto-library',
      version="1.1.0",
      description='Robot Framework test library for Palo Alto Networks',
      long_description=readme(),
      classifiers=[
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3.6',
        'Framework :: SPARTAN Robot Framework',
      ],
      author='info@gmail.com',
      author_email='devops@gmail.com',
      packages=['PaloAltoNetworksLibrary'],
      install_requires=[
          'Click',
          'pyYaml',
          'jinja2',
          'textfsm',
          'xmltodict',
          'pan-os-python',
          'robotframework',
          'pyjwt'
      ],
      extras_require={
          'dev': [
              'flake8==3.8.3',
              'pylint==2.5.3',
              'black==19.10b0',
              'isort==4.3.21',
              'vulture',
              'mypy'
          ]
      },
      platforms='any',
      include_package_data=True,
      zip_safe=False)