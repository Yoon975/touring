document.addEventListener("DOMContentLoaded", function () {
  let isPwChecked = false;

  const pw1Input = document.getElementById("pw1");
  const pw2Input = document.getElementById("pw2");
  const pw3Input = document.getElementById("pw3");
  const checkBtn = document.getElementById("checkPwBtn");
  const updateForm = document.getElementById("updateForm");


  checkBtn.addEventListener("click", function () {
    const id = document.getElementById("userId").value;
    const pw = pw1Input.value.trim();
    const resultSpan = document.getElementById("pwCheckResult");

    if (!pw) {
      alert("현재 비밀번호를 입력해주세요.");
      return;
    }

    fetch("/touring/user/pw-check", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: `id=${encodeURIComponent(id)}&pw=${encodeURIComponent(pw)}`
    })
      .then(response => response.ok ? response.text() : Promise.reject("네트워크 오류"))
      .then(text => {
        const match = text.split("=")[1] === 'true';
        if (match) {
        resultSpan.textContent = "비밀번호 확인됨.";
        resultSpan.style.color = "green";
        document.getElementById("newPwFields").style.display = "block";
        isPwChecked = true;
      
       
        const onlyBackBtn = document.getElementById("onlyBackBtn");
        if (onlyBackBtn) onlyBackBtn.style.display = "none";
      }else {
          resultSpan.textContent = "비밀번호가 일치하지 않습니다.";
          resultSpan.style.color = "red";
          document.getElementById("newPwFields").style.display = "none";
          isPwChecked = false;
        }
      })
      .catch(error => {
        console.error(error);
        resultSpan.textContent = "서버 오류 발생";
        resultSpan.style.color = "red";
        document.getElementById("newPwFields").style.display = "none";
        isPwChecked = false;
      });
  });


  pw1Input.addEventListener("keydown", function(e) {
    if (e.key === "Enter") {
      e.preventDefault();
      checkBtn.click(); // 현재 비밀번호 확인
    }
  });

  function submitFormOnEnter(e) {
    if (e.key === "Enter") {
      e.preventDefault();
      updateForm.requestSubmit(); 
    }
  }

  pw2Input.addEventListener("keydown", submitFormOnEnter);
  pw3Input.addEventListener("keydown", submitFormOnEnter);


  updateForm.addEventListener("submit", function (e) {
    const pw1 = pw1Input.value.trim();
    const pw2 = pw2Input.value.trim();
    const pw3 = pw3Input.value.trim();

    if (!pw2 || !pw3) { alert("새 비밀번호를 입력해주세요."); e.preventDefault(); return; }
    
    if (pw2.includes(" ")) {
       alert("비밀번호에는 공백을 포함할 수 없습니다.");
        e.preventDefault();
        return;
    }
    
    if (pw2.length < 5 || pw2.length > 20) {
        alert("비밀번호는 5~20자 이내여야 합니다.");
        e.preventDefault();
        return;
    }
    
    if (pw2 !== pw3) { alert("새비밀번호가 일치하지 않습니다."); e.preventDefault(); return; }
    if (pw1 === pw2 && pw2 === pw3) { alert("현재 비밀번호와 다른 비밀번호를 입력해주세요."); e.preventDefault(); return; }
    if (!isPwChecked) { alert("현재 비밀번호를 먼저 확인해주세요."); e.preventDefault(); return; }

    const confirmChange = confirm("정말 비밀번호를 변경하시겠습니까?");
    if (!confirmChange) {
      e.preventDefault();
    }
  });
});




