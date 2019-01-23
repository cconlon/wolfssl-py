set -e
set +x

# update pip for newer TLS support
curl https://bootstrap.pypa.io/get-pip.py | python
pip install --upgrade pip

# update virtualenv
python -m pip install virtualenv

# install cffi module
python -m pip install cffi

python setup.py bdist_wheel
pip install -r requirements/test.txt
set +e
pip uninstall -y wolfssl
set -e
pip install wolfssl --no-index -f dist
rm -rf tests/__pycache__
py.test tests
