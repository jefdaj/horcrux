from setuptools import setup

setup(
    name='horcrux',
    version='0.9',
    python_requires='>3.7',
    py_modules=['horcrux'],
    install_requires=[
        'docopt',
        'python-gnupg',
    ],
    entry_points='''
        [console_scripts]
        horcrux=horcrux:main
    ''',
)
