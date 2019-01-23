set -e
set +x

for PYVERSION in 2.7 3.4 3.5 3.6; do
    PYTHONEXE=/Library/Frameworks/Python.framework/Versions/${PYVERSION}/bin/python${PYVERSION}
    export PATH=$PATH:/Library/Frameworks/Python.framework/Versions/${PYVERSION}/bin

    # update pip for newer TLS support
    curl https://bootstrap.pypa.io/get-pip.py | python
    pip install --upgrade pip

    # update virtualenv and setuptools
    $PYTHONEXE -m pip install virtualenv
    #$PYTHONEXE pip install --upgrade setuptools

    virtualenv -p /Library/Frameworks/Python.framework/Versions/${PYVERSION}/bin/python${PYVERSION} venv_${PYVERSION}
    . ./venv_${PYVERSION}/bin/activate

    python setup.py bdist_wheel
    pip install -r requirements/test.txt
    set +e
    pip uninstall -y wolfssl
    set -e
    pip install wolfssl --no-index -f dist
    rm -rf tests/__pycache__
    py.test tests
    deactivate
done
