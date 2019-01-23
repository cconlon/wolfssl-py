set -e
set +x

for PYVERSION in 2.7 3.4 3.5 3.6; do
    PYTHONBIN=/Library/Frameworks/Python.framework/Versions/${PYVERSION}/bin
    PYTHONEXE=${PYTHONBIN}/python${PYVERSION}
    export PATH="${PYTHONBIN}":$PATH

    # update pip for newer TLS support
    #curl https://bootstrap.pypa.io/get-pip.py | ${PYTHONEXE}
    #"${PYTHONBIN}/pip" install --upgrade pip

    brew update
    brew install python2
    brew install python3

    which python
    python --version
    which pip
    pip --version
    pip list

    # update virtualenv and setuptools
    ${PYTHONEXE} -m pip install virtualenv
    #$PYTHONEXE -m pip install virtualenv
    #$PYTHONEXE pip install --upgrade setuptools

    virtualenv -p ${PYTHONEXE} venv_${PYVERSION}
    . ./venv_${PYVERSION}/bin/activate

    which python
    python --version
    which pip
    pip --version
    pip list

    ${PYTHONEXE} setup.py bdist_wheel
    "${PYTHONBIN}/pip" install -r requirements/test.txt
    set +e
    "${PYTHONBIN}/pip" uninstall -y wolfssl
    set -e
    "${PYTHONBIN}/pip" install wolfssl --no-index -f dist
    rm -rf tests/__pycache__
    py.test tests
    deactivate
done
