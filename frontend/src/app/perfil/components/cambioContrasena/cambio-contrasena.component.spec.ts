import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CambioContrasenaComponent } from './cambio-contrasena.component';

describe('CambioContrasenaComponent', () => {
  let component: CambioContrasenaComponent;
  let fixture: ComponentFixture<CambioContrasenaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CambioContrasenaComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CambioContrasenaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
